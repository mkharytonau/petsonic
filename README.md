# petsonic

Ruby web scraper.

## How to run?
```
$ git clone https://github.com/Mikita-Kharitonau/petsonic.git
$ cd petsonic
$ bundle install
$ ruby bin/main.rb category_url output_path
```

## Workflow example
```
$ ruby bin/main.rb
usage: main.rb category_url output_path 

Petsonic application.

positional arguments:
  category_url      Category url.
  output_path       Output file name.

```
Running scraper will provide the following logs to stdout:
```
$ ruby bin/main.rb https://www.petsonic.com/huesos-para-perro/ output.csv
I, [2019-08-12T10:34:00.516183 #22847]  INFO -- : Starting the Petsonic application.
I, [2019-08-12T10:34:00.516434 #22847]  INFO -- : Fetching data from https://www.petsonic.com/huesos-para-perro/ ...
I, [2019-08-12T10:34:01.615413 #22847]  INFO -- : Category page 1 was successfully fetched, starting to iterate over products...
I, [2019-08-12T10:34:01.617009 #22847]  INFO -- : Fetching https://www.petsonic.com/huesos-delibones-para-perro.html product variants...
I, [2019-08-12T10:34:01.617083 #22847]  INFO -- : Fetching data from https://www.petsonic.com/huesos-delibones-para-perro.html ...
I, [2019-08-12T10:34:02.423533 #22847]  INFO -- : Product page https://www.petsonic.com/huesos-delibones-para-perro.html was successfully fetched, starting to iterate over variants...
D, [2019-08-12T10:34:02.425616 #22847] DEBUG -- : Variant url: https://www.petsonic.com/huesos-delibones-para-perro.html#/1052-tamano-7_cm
I, [2019-08-12T10:34:03.241510 #22847]  INFO -- : Successfully extracted ProductVariant( Huesos Delibones para Perro - 7 cm, 3.24, https://img1.petsonic.com/13301-large_default/huesos-delibones-para-perro.jpg variant.
D, [2019-08-12T10:34:03.242782 #22847] DEBUG -- : Variant url: https://www.petsonic.com/huesos-delibones-para-perro.html#/489-tamano-11_cm
I, [2019-08-12T10:34:04.054649 #22847]  INFO -- : Successfully extracted ProductVariant( Huesos Delibones para Perro - 11 cm, 3.49, https://img1.petsonic.com/13301-large_default/huesos-delibones-para-perro.jpg variant.
I, [2019-08-12T10:34:04.054716 #22847]  INFO -- : Successfully retrieved 2 variant(s), writing to file...
I, [2019-08-12T10:34:04.055882 #22847]  INFO -- : No need to load next page, exiting...
I, [2019-08-12T10:34:04.055936 #22847]  INFO -- : Successfully finished, please, check output.csv file for results.
```
And create output.csv:
```
name,price,image
 Huesos Delibones para Perro - 7 cm,3.24,https://img1.petsonic.com/13301-large_default/huesos-delibones-para-perro.jpg
 Huesos Delibones para Perro - 11 cm,3.49,https://img1.petsonic.com/13301-large_default/huesos-delibones-para-perro.jpg
```

We also have some simple validations:
```
$ ruby bin/main.rb incorrect_url output.csv
I, [2019-08-12T10:39:13.751534 #23023]  INFO -- : Starting the Petsonic application.
I, [2019-08-12T10:39:13.751706 #23023]  INFO -- : Fetching data from incorrect_url ...
E, [2019-08-12T10:39:13.852477 #23023] ERROR -- : Can't get response from incorrect_url, please, make sure you have an Internet connection and this page is exists.
E, [2019-08-12T10:39:13.852740 #23023] ERROR -- : Program not properly finished, please, see logs above for more details.
```

