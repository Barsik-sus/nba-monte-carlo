build:
	meltano install

run:
	meltano run tap-spreadsheets-anywhere target-duckdb --full-refresh dbt-duckdb:build

parquet:
	meltano run tap-spreadsheets-anywhere target-parquet --full-refresh;\
	meltano invoke dbt-duckdb build --target parquet
