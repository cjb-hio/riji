#!/usr/bin/env bash
set -euo pipefail

./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
