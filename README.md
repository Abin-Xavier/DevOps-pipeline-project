# DevOps Pipeline Project

[![CI](https://github.com/Abin-Xavier/DevOps-pipeline-project/actions/workflows/ci.yml/badge.svg)](https://github.com/Abin-Xavier/DevOps-pipeline-project/actions/workflows/ci.yml)

A .NET 10 + Angular task tracker used to practise a full DevOps workflow: containers, CI/CD, infrastructure as code and monitoring.

## What works so far

- .NET Web API with a `/health` endpoint and SQL Server storage (Entity Framework Core migrations)
- Angular frontend served by Nginx
- Multi-stage Dockerfiles with health checks
- Docker Compose stack: frontend, API and SQL Server with a persistent volume
- GitHub Actions CI: builds the API and frontend, then pushes Docker images to Docker Hub tagged with the commit SHA

## Run it locally

1. Copy `docker/.env.example` to `docker/.env` and set a strong `MSSQL_SA_PASSWORD`.
2. From the `docker` folder run `docker compose up -d --build`.
3. Open http://localhost:4200

## Roadmap

Terraform (AWS), Ansible, CD with automatic rollback, Jenkins, Prometheus and Grafana, Kubernetes with Helm.
