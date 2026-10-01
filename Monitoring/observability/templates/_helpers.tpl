{{/*
Nombre base del chart.
*/}}
{{- define "observability.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Etiquetas estándar.
*/}}
{{- define "observability.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "observability.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "observability.selectorLabels" -}}
app.kubernetes.io/name: {{ include "observability.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Etiquetas de DESCUBRIMIENTO del Prometheus Operator externo.

Todo objeto que el Operator tiene que encontrar (Probe, PodMonitor, ServiceMonitor,
PrometheusRule) lleva estas etiquetas, y salen de un único sitio en values. Si el
selector real del equipo de monitorización resulta ser otro, se corrige en una línea
en vez de en cada plantilla.
*/}}
{{- define "observability.discoveryLabels" -}}
{{- toYaml .Values.discoveryLabels }}
{{- end }}

{{/*
Nombre del blackbox-exporter.
*/}}
{{- define "observability.blackbox.fullname" -}}
{{- default "blackbox-exporter" .Values.blackbox.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
