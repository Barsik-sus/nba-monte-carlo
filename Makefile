build:
	meltano install

docker-build:
	docker build -t mdsbox .

superset-visuals:
	meltano install utility superset
	meltano invoke superset fab create-admin --username admin --firstname lebron --lastname james --email admin@admin.org --password password
	meltano invoke superset:ui

docker-run-superset:
	docker run \
		--publish 32191:8088 \
	 	--env MELTANO_CLI_LOG_LEVEL=WARNING \
		--env MDS_SCENARIOS=10000 \
		--env MDS_INCLUDE_ACTUALS=true \
		--env MDS_LATEST_RATINGS=true \
		--env MDS_ENABLE_EXPORT=true \
		--env ENVIRONMENT=docker \
		mdsbox make superset-visuals

evidence-build:
	cd analyze && npm i -force

evidence-run:
	cd analyze && npm run dev -- --host 0.0.0.0

evidence-visuals:
	make evidence-build
	make evidence-run

docker-run-evidence:
		docker run \
		--publish 3000:3000 \
	 	--env MELTANO_CLI_LOG_LEVEL=WARNING \
		--env MDS_SCENARIOS=10000 \
		--env MDS_INCLUDE_ACTUALS=true \
		--env MDS_LATEST_RATINGS=true \
		--env MDS_ENABLE_EXPORT=true \
		--env ENVIRONMENT=docker \
		mdsbox make evidence-visuals
