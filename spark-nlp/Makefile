docker-build:
	docker build --rm --force-rm -t dream2globe/spark-nlp:spark-2.4.7 .

docker-run:
	docker-compose up

clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name __pycache__ | xargs rm -fr {}

.PHONY: jupyter-hdfs jupyter-docker clean
