build:
	docker build -t soames:latest .

bundle:
	docker build --target=base -t soames:test .
	docker run --volume $$(pwd):/opt --rm soames:test bundle install --quiet

test:
	docker build --target=test -t soames:test .
	docker run --rm soames:test bundle exec rspec ${SPEC}

sh:
	docker build --target=test -t soames:test .
	docker run -it --rm -v $$(pwd):/opt soames:test sh

release:
	docker build --target=release -t soames:latest .
	docker run --volume $$(pwd):/opt soames:latest bundle exec gem build soames.gemspec
