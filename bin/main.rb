require_relative '../lib/product_variant'
require_relative '../config/config'
require_relative '../lib/csv_writer'

require 'csv'
require 'curb'
require 'logger'
require 'nokogiri'


def category(url, page_number=1, logger=Logger.new(STDOUT))
  category_url = category_url(url, page_number)

  logger.info(fetching_data_from(category_url))

  begin
    html = load_page(category_url)
  rescue Curl::Err::CurlError
    logger.error(error_message(url))
    raise Curl::Err::CurlError
  end

  doc = Nokogiri::HTML(html)

  logger.info(category_page_fetched(page_number))

  if doc.xpath(CATEGORY_PAGE_CORRECTNESS).count.zero?
    logger.error(incorrect_category(category_url))
    raise Curl::Err::CurlError
  end

  doc.xpath(PRODUCT_SELECTOR).each do |p|
    product_url = p.attr('href')
    logger.info(fetching_product_variants(product_url))

    begin
      product_variants = product(product_url)
    rescue Curl::Err::CurlError
      logger.error(product_error(product_url))
      next
    end

    logger.info(variants_retrieved(product_variants.count))

    csv_object = CsvWriter.writer
    product_variants.each do |pv|
      csv_object << [pv.name, pv.price, pv.image]
    end
  end

  need_more = need_more?(doc, page_number)
  unless need_more
    logger.info(no_need_to_load_more)
    return
  end

  category(url, page_number + 1)
end

def category_url(root_url, page_number)
  page_number < 2 ? root_url : root_url + "?p=#{page_number}"
end

def need_more?(doc, page_number)
  product_counter = doc.xpath(PRODUCT_COUNTER).first.content.to_i
  product_counter > page_number * 25
end

def product(url, logger=Logger.new(STDOUT))
  logger.info(fetching_data_from(url))

  html = load_page(url)
  doc = Nokogiri::HTML(html)

  logger.info(product_page_fetched(url))
  name = doc.xpath(PRODUCT_NAME).first.content
  product_variants = []
  doc.xpath(PRODUCT_VARIANT).each do |variant|
    variant_raw_count = variant.xpath(VARIANT_COUNT).first.content
    variant_raw_price = variant.xpath(VARIANT_PRICE).first.content
    variant_identifier = variant.xpath(VARIANT_IDENTIFIER).first.attr('value')
    variants_type = doc.xpath(VARIANTS_TYPE).first.content
    variant_url = variant_url(url, variants_type, variant_identifier, variant_raw_count)

    logger.debug(variant_url_msg(variant_url))

    # Trying to retrieve variant specific image, but with no success:
    # e.g. https://www.petsonic.com/huesos-delibones-para-perro.html#/489-tamano-11_cm
    # in browser shows different from https://www.petsonic.com/huesos-delibones-para-perro.html
    # image, but if we take this page with curb - we get old product image here.
    # Seems like images swaps with javascript when page is loading.
    # May be there is another way to get a variant specific image?
    variants_html = load_page(variant_url)
    variants_doc = Nokogiri::HTML(variants_html)

    image = variants_doc.xpath(VARIANT_IMAGE).first.attr('src')

    pv = ProductVariant.new(
      product_variant_name(name, variant_raw_count),
      variant_price(variant_raw_price),
      image
    )

    logger.info(product_variant_extracted(pv))

    product_variants.append(pv)
  end

  product_variants
end

def variant_url(product_url, variant_type, variant_identifier, variant_count)
  return product_url unless SUPPORTED_VARIANTS_TYPES.include?(variant_type)

  variant_type = 'Tamano ' if variant_type == 'Tamaño '
  variant_type = variant_type.delete_suffix(' ').downcase
  variant_url_postfix = "#{variant_identifier}-#{variant_type}-#{variant_count.tr(' ', '_')}"

  "#{product_url}#/#{variant_url_postfix}"
end

def product_variant_name(product_name, variant_count)
  "#{product_name} - #{variant_count}"
end

def variant_price(raw_price)
  raw_price.to_f
end

def load_page(url)
  http = Curl.get(url)
  html = http.body_str
  raise Curl::Err::CurlError if html.empty?

  html
end

if $PROGRAM_NAME == __FILE__

  if ARGV.count < 2
    puts "usage: main.rb category_url output_path \n\n"\
          "Petsonic application.\n\n"\
          "positional arguments:\n"\
          "  category_url      Category url.\n"\
          "  output_path       Output file name.\n\n"
    return
  end

  logger = Logger.new(STDOUT)
  logger.info(starting_application)

  begin
    CsvWriter.new(ARGV[1])
    category(ARGV.first)
  rescue Curl::Err::CurlError
    logger.error(not_properly_finished)
    return
  end

  logger.info(successfully_finished(ARGV[1]))
end