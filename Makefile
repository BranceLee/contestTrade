CONFIG_PATH?=$(PWD)/config.yaml

build:
	docker build -t finstep/contesttrade:v1.1 .

start:
	docker run -it --rm --name contest_trade -v $(CONFIG_PATH):/ContestTrade/config.yaml finstep/contesttrade:v1.1

auto:
	docker run -i --rm --name contest_trade -v $(CONFIG_PATH):/ContestTrade/config.yaml finstep/contesttrade:v1.1