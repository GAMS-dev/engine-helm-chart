{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gams-engine.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 53 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 53 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gams-engine.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}


{{- define "gams-engine.prefixname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 50 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 50 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 50 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gams-engine.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "gams-engine.labels" -}}
helm.sh/chart: {{ include "gams-engine.chart" . }}
{{ include "gams-engine.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gams-engine.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gams-engine.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "gams-engine.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "gams-engine.name" . ) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Hosts of a connection string, e.g. "h1:27017,h2:27017". */}}
{{- define "gams-engine.uri.hosts" -}}
{{- regexFind "^[^/?]+" (regexReplaceAll "^[^:]+://([^@]+@)?" . "") -}}
{{- end -}}

{{/* Port of the first host of a connection string, or "". */}}
{{- define "gams-engine.uri.port" -}}
{{- regexFind ":[0-9]+$" (include "gams-engine.uri.hosts" . | splitList "," | first) | trimPrefix ":" -}}
{{- end -}}

{{/* Database path segment of a connection string, or "". */}}
{{- define "gams-engine.uri.database" -}}
{{- regexFind "^/[^/?]+" (regexReplaceAll "^[^:]+://[^/?]*" . "") | trimPrefix "/" -}}
{{- end -}}

{{- define "gams-engine.postgres.connectionString" -}}
{{- required "A valid 'postgresql.externalDatabase.connectionString' is required when externalDatabase is enabled!" .Values.postgresql.externalDatabase.connectionString -}}
{{- end -}}

{{- define "gams-engine.mongo.connectionString" -}}
{{- required "A valid 'mongodb.externalDatabase.connectionString' is required when externalDatabase is enabled!" .Values.mongodb.externalDatabase.connectionString -}}
{{- end -}}

{{/* PostgreSQL host (first host, without port) from the external connection string. */}}
{{- define "gams-engine.postgres.host" -}}
{{- regexReplaceAll ":[0-9]+$" (include "gams-engine.uri.hosts" (include "gams-engine.postgres.connectionString" .) | splitList "," | first) "" -}}
{{- end -}}

{{/* PostgreSQL port from the external connection string, default 5432. */}}
{{- define "gams-engine.postgres.port" -}}
{{- include "gams-engine.uri.port" (include "gams-engine.postgres.connectionString" .) | default "5432" -}}
{{- end -}}

{{/* MongoDB port from the external connection string, else networkPolicy.port (e.g. for mongodb+srv). */}}
{{- define "gams-engine.mongo.port" -}}
{{- include "gams-engine.uri.port" (include "gams-engine.mongo.connectionString" .) | default .Values.mongodb.externalDatabase.networkPolicy.port -}}
{{- end -}}

{{/* MongoDB database name: connection string path if external, else mongodb.database. */}}
{{- define "gams-engine.mongo.databaseName" -}}
{{- if .Values.mongodb.externalDatabase.enabled -}}
  {{- required "The MongoDB connection string must include a database path (the segment after the host, e.g. /mydb)" (include "gams-engine.uri.database" (include "gams-engine.mongo.connectionString" .)) -}}
{{- else -}}
  {{- .Values.mongodb.database -}}
{{- end -}}
{{- end -}}

{{/* PostgreSQL database name: connection string path if external, else postgresql.database. */}}
{{- define "gams-engine.postgres.databaseName" -}}
{{- if .Values.postgresql.externalDatabase.enabled -}}
  {{- required "The PostgreSQL connection string must include a database path (the segment after the host, e.g. /mydb)" (include "gams-engine.uri.database" (include "gams-engine.postgres.connectionString" .)) -}}
{{- else -}}
  {{- .Values.postgresql.database -}}
{{- end -}}
{{- end -}}
