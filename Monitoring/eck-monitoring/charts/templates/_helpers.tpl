{{/*
Kibana dns
*/}}
{{- define "kibana.dns" -}}
kibana-{{ .Values.namespaceTag }}.{{ .Values.domainSuffix }}
{{- end -}}
{{/*
Kibana full URL with base path
*/}}
{{- define "kibana.dns.fullPath" -}}
https://{{ template "kibana.dns" . }}
{{- end -}}



{{/*
Elasticsearch api dns
*/}}
{{- define "elasticsearch.dns" -}}
elasticsearch-{{ .Values.namespaceTag }}.{{ .Values.domainSuffix }}
{{- end -}}

{{/*
Logstash input dns (for beats)
*/}}
{{- define "logstash.dns" -}}
logstash-{{ .Values.logstash.beats.pipelines_group_name }}-{{ .Values.namespaceTag }}.{{ .Values.domainSuffix }}
{{- end -}}


{{/*
Logstash input dns for many ingressRouteTCPs
*/}}
{{- define "logstash.dns.array" -}}
{{ $concatUrl := ( printf ".%s"  (include "logstash.dns" .)) }}
{{ $urlPrefix := (default "l" .Values.logstash.urlPrefix) }}
{{ $maxRange := (.Values.logstash.count_beats |int ) }}
{{- range $index :=  until $maxRange -}}
    {{- $urlPrefix}}{{$index }}{{ $concatUrl }}{{if lt $index (sub $maxRange 1)  }},{{end}}
{{- end -}} 
{{- end -}}


{{/*
Filebeat input dns
*/}}
{{- define "filebeat.dns" -}}
filebeat-{{ .Values.namespaceTag }}.{{ .Values.domainSuffix }}
{{- end -}}


{{/*
Filebeat for agents input dns
*/}}
{{- define "filebeat4agents.dns" -}}
filebeat4agents-{{ .Values.namespaceTag }}.{{ .Values.domainSuffix }}
{{- end -}}

{{/*
Apm api dns
*/}}
{{- define "apmServer.dns" -}}
apm-{{ .Values.namespaceTag }}.{{ .Values.domainSuffix }}
{{- end -}}

{{/*
OTEL colletor api dns
*/}}
{{- define "collector.dns" -}}
collector-{{ .Values.namespaceTag }}.{{ .Values.domainSuffix }}
{{- end -}}


{{/*
Metricbeat HPA dns
*/}}
{{- define "metricbeat_hpa.dns" -}}
mbHPA-{{ .Values.namespaceTag }}.{{ .Values.domainSuffix }}
{{- end -}}
