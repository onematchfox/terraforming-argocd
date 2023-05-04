{{/*
Expand the name of the chart.
*/}}
{{- define "eks-application.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "eks-application.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eks-application.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Build image name
*/}}
{{- define "eks-application.image" -}}
{{- .Values.image.repository }}
{{- end }}

{{/*
Build image tag
*/}}
{{- define "eks-application.image-tag" -}}
{{- .Values.image.tag }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "eks-application.labels" -}}
helm.sh/chart: {{ include "eks-application.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- range $k, $v := .Values.additionalLabels }}
{{ printf "%s: %s" $k $v }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "eks-application.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "eks-application.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "eks-application.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "eks-application.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
