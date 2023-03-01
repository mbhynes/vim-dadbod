let g:bq_default_params = {
  \ 'use_legacy_sql': 'false',
  \ }

let g:bq_global_params = [
  \ 'api',
  \ 'api_version',
  \ 'apilog',
  \ 'bigqueryrc',
  \ 'ca_certificates_file',
  \ 'dataset_id',
  \ 'debug_mode',
  \ 'nodebug_mode',
  \ 'disable_ssl_validation',
  \ 'nodisable_ssl_validation',
  \ 'discovery_file',
  \ 'enable_gdrive',
  \ 'noenable_gdrive',
  \ 'fingerprint_job_id',
  \ 'nofingerprint_job_id',
  \ 'format',
  \ 'headless',
  \ 'noheadless',
  \ 'httplib2_debuglevel',
  \ 'job_id',
  \ 'job_property',
  \ 'jobs_query_use_request_id',
  \ 'nojobs_query_use_request_id',
  \ 'jobs_query_use_results_from_response',
  \ 'nojobs_query_use_results_from_response',
  \ 'location',
  \ 'max_rows_per_request',
  \ 'mtls',
  \ 'nomtls',
  \ 'project_id',
  \ 'proxy_address',
  \ 'proxy_password',
  \ 'proxy_port',
  \ 'proxy_username',
  \ 'quiet',
  \ 'noquiet',
  \ 'synchronous_mode',
  \ 'nosynchronous_mode',
  \ 'trace',
  \ 'use_regional_endpoints',
  \ 'nouse_regional_endpoints',
  \ ]

function! db#adapter#bigquery#auth_input() abort
  return 'select 1;'
endfunction

function! s:command_for_url(url, action) abort
  let params = db#url#parse(a:url).params
  let cmd = ['bq']
  let subcmd = [a:action]
  for [k, v] in items(extend(g:bq_default_params, params))
    let op = '--'.k.'='.v
    if index(g:bq_global_params, k) >= 0
      call add(cmd, op)
    else
      call add(subcmd, op)
    endif
  endfor
  return cmd + subcmd
endfunction

function! db#adapter#bigquery#filter(url) abort
  return s:command_for_url(a:url, 'query')
endfunction

function! db#adapter#bigquery#interactive(url) abort
  return s:command_for_url(a:url, 'query')
endfunction

function! db#adapter#bigquery#complete_database(url) abort
  let pre = matchstr(a:url, '[^:]\+://.\{-\}/')
  let cmd = s:command_for_url(pre, 'ls')
  let out = db#systemlist(cmd)
  return out[2:]
endfunction

