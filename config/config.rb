SUPPORTED_VARIANTS_TYPES = %w[Unidades  Pesos  Tallas  Tamaño ].freeze

# xpath selectors
PRODUCT_COUNTER = "//div[@id='center_column']/span[@class='heading-counter']".freeze
PRODUCT_NAME = "//h1[@class='product_main_name']".freeze
PRODUCT_VARIANT = "//ul[@class='attribute_radio_list']/li".freeze
VARIANT_COUNT = "label/span[@class='radio_label']".freeze
VARIANT_PRICE = "label/span[@class='price_comb']".freeze
VARIANT_IDENTIFIER = "input".freeze
VARIANTS_TYPE = "//div[@id='attributes']/fieldset[@class='attribute_fieldset']/label[@class='attribute_label new-label-group l-caracteristicas']".freeze
VARIANT_IMAGE = "//div[@id='image-block']/span/img[@id='bigpic']".freeze
CATEGORY_PAGE_CORRECTNESS = "//div[@id='center_column']/h1[@class='heading page-heading product-listing']".freeze
PRODUCT_SELECTOR = "//li/div/div/div/a[@class='product_img_link product-list-category-img']".freeze

# log messages
def fetching_data_from(url)
  "Fetching data from #{url} ..."
end

def product_page_fetched(url)
  "Product page #{url} was successfully fetched, starting to iterate over variants..."
end

def product_variant_extracted(pv)
  "Successfully extracted #{pv.to_s} variant."
end

def variant_url_msg(url)
  "Variant url: #{url}"
end

def error_message(url)
  "Can't get response from #{url}, please, make sure you have an Internet connection and this page is exists."
end

def product_error(url)
  "Error while parsing #{url} product, please, make sure you have an Internet connection and this page is exists."
end

def category_page_fetched(num)
  "Category page #{num} was successfully fetched, starting to iterate over products..."
end

def incorrect_category(url)
  "#{url} category page is incorrect, seems like this category doesn't exists."
end

def fetching_product_variants(url)
  "Fetching #{url} product variants..."
end

def variants_retrieved(num)
  "Successfully retrieved #{num} variant(s), writing to file..."
end

def no_need_to_load_more
  'No need to load next page, exiting...'
end

def starting_application
  'Starting the Petsonic application.'
end

def not_properly_finished
  'Program not properly finished, please, see logs above for more details.'
end

def successfully_finished(path)
  "Successfully finished, please, check #{path} file for results."
end