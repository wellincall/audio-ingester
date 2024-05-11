# Audio File Parser

This project was developed in Ruby 3.3.1 and bundled with bundler 2.5.9. In order to better manage the development environment, a Dockerfile was created to make it easier to replicate the app.

To be able to create a container for it, you first need to build an image for this project.

```sh
$ docker build -t audio-ingester:latest .
```

This will create an image for the project we want to run.

To create a container, we also need to bind the current working directory to the container. Then we can access the output generated by our script. We achieve that by passing the -v parameters to the run command. 

```sh
$ docker run -it --rm -v ./:/app/ audio-ingester
```

The command above is going to run the script `audio_parser.rb` and generate the output folder;

## Running tests

Tests were added to the project using RSpec. You can run them with the following command:

```sh
$ docker run -it --rm audio-ingester bundle exec rspec 
```

## Assumptions

It was assumed the field `BitDepth` corresponds to the field `BitsPerSample`, according to [this reference](http://soundfile.sapp.org/doc/WaveFormat/).
