" Vim syntax file
" Language: OpenSIPS configuration
" Maintainer: Your Name
" Latest Revision: 2025

if exists("b:current_syntax")
  finish
endif

" Case sensitive
syn case match

" =============================================================================
" Strings (with contained variables and SIP methods for highlighting inside strings)
" =============================================================================
syn region  opensipsString      start='"' skip='\\"' end='"' contains=opensipsCoreVar,opensipsVariable,opensipsStringVar,opensipsStringMethod
syn region  opensipsString      start="'" skip="\\'" end="'" contains=opensipsCoreVar,opensipsVariable,opensipsStringVar,opensipsStringMethod

" Variables inside strings (need to be defined with 'contained' for proper matching)
syn match   opensipsStringVar   contained "\$\(ru\|rU\|rd\|rp\|rP\|rv\|ou\|oU\|od\|op\|oP\)\>"
syn match   opensipsStringVar   contained "\$\(fu\|fU\|fd\|fn\|ft\|tu\|tU\|td\|tn\|tt\)\>"
syn match   opensipsStringVar   contained "\$\(si\|sp\|sP\|Ri\|Rp\|ci\|cs\|cl\|cT\|ct\)\>"
syn match   opensipsStringVar   contained "\$\(ua\|mb\|ml\|mi\|rb\|rm\|rs\|rr\|rc\)\>"
syn match   opensipsStringVar   contained "\$\(du\|dd\|dp\|dP\|ds\|di\|dip\|dir\)\>"
syn match   opensipsStringVar   contained "\$\(au\|ad\|aU\|ar\|an\|adu\|Au\|ai\)\>"
syn match   opensipsStringVar   contained "\$\(pu\|pU\|pd\|pn\|pp\|re\|rt\)\>"
syn match   opensipsStringVar   contained "\$\(Ts\|Tsm\|TS\|Tf\|mf\|bf\)\>"
syn match   opensipsStringVar   contained "\$\(retcode\|T_branch_idx\|cfg_line\|cfg_file\)\>"
syn match   opensipsStringVar   contained "\$\(ru_q\|sdp\|log_level\|xlog_level\)\>"
syn match   opensipsStringVar   contained "\$\(socket_in\|socket_out\)\>"
syn match   opensipsStringVar   contained "\$\(msg\.is_request\|msg\.type\)\>"
syn match   opensipsStringVar   contained "\$\(err\.class\|err\.level\|err\.info\|err\.rcode\|err\.rreason\)\>"
syn match   opensipsStringVar   contained "\$\(var\|avp\|hdr\|hdrcnt\|param\|branch\|time\|route\)([^)]*)"
syn match   opensipsStringVar   contained "\$[a-zA-Z_][a-zA-Z0-9_]*"
syn match   opensipsStringVar   contained "\$[a-zA-Z_][a-zA-Z0-9_]*([^)]*)"

" SIP Methods inside strings (for is_method("INVITE|BYE") patterns)
syn match   opensipsStringMethod contained "\<\(INVITE\|ACK\|CANCEL\|BYE\|REGISTER\|OPTIONS\|PRACK\|UPDATE\)\>"
syn match   opensipsStringMethod contained "\<\(SUBSCRIBE\|NOTIFY\|PUBLISH\|MESSAGE\|INFO\|REFER\)\>"

" =============================================================================
" Numbers
" =============================================================================
syn match   opensipsNumber      "\<\d\+\>"
syn match   opensipsNumber      "\<0x[0-9a-fA-F]\+\>"

" =============================================================================
" Variables - Core pseudo-variables (highlighted in brown/orange)
" =============================================================================
" Simple core variables: $ru, $rU, $si, $fu, etc. (2-3 letter vars)
syn match   opensipsCoreVar     "\$\(ru\|rU\|rd\|rp\|rP\|rv\|ou\|oU\|od\|op\|oP\)\>"
syn match   opensipsCoreVar     "\$\(fu\|fU\|fd\|fn\|ft\|tu\|tU\|td\|tn\|tt\)\>"
syn match   opensipsCoreVar     "\$\(si\|sp\|sP\|Ri\|Rp\|ci\|cs\|cl\|cT\|ct\)\>"
syn match   opensipsCoreVar     "\$\(ua\|mb\|ml\|mi\|rb\|rm\|rs\|rr\|rc\)\>"
syn match   opensipsCoreVar     "\$\(du\|dd\|dp\|dP\|ds\|di\|dip\|dir\)\>"
syn match   opensipsCoreVar     "\$\(au\|ad\|aU\|ar\|an\|adu\|Au\|ai\)\>"
syn match   opensipsCoreVar     "\$\(pu\|pU\|pd\|pn\|pp\|re\|rt\)\>"
syn match   opensipsCoreVar     "\$\(Ts\|Tsm\|TS\|Tf\|mf\|bf\)\>"
syn match   opensipsCoreVar     "\$\(retcode\|T_branch_idx\|cfg_line\|cfg_file\)\>"
syn match   opensipsCoreVar     "\$\(ru_q\|sdp\|log_level\|xlog_level\)\>"
syn match   opensipsCoreVar     "\$\(socket_in\|socket_out\)\>"
syn match   opensipsCoreVar     "\$\(msg\.is_request\|msg\.type\)\>"
syn match   opensipsCoreVar     "\$\(err\.class\|err\.level\|err\.info\|err\.rcode\|err\.rreason\)\>"

" Indexed core variables: $var(name), $avp(name), $hdr(name), $param(idx), etc.
syn match   opensipsCoreVar     "\$\(var\|avp\|hdr\|hdrcnt\|param\|branch\|time\|route\)([^)]*)"

" General variables (fallback for user-defined or less common)
syn match   opensipsVariable    "\$[a-zA-Z_][a-zA-Z0-9_]*" contains=opensipsCoreVar
" Indexed variables: $something(name) - not covered above
syn match   opensipsVariable    "\$[a-zA-Z_][a-zA-Z0-9_]*([^)]*)" contains=opensipsCoreVar
" Parenthesized: $(var)
syn match   opensipsVariable    "\$([a-zA-Z_][a-zA-Z0-9_]*)"
" Braced: ${var}
syn match   opensipsVariable    "\${[^}]*}"

" =============================================================================
" Route Definitions (with full route block matching)
" =============================================================================
" Match route keywords
syn keyword opensipsRouteType   route branch_route failure_route onreply_route
syn keyword opensipsRouteType   error_route local_route startup_route timer_route
syn keyword opensipsRouteType   event_route
" Match route names in brackets
syn match   opensipsRouteName   "\[[-a-zA-Z0-9_:,]*\]"
" Match full route definition line for better highlighting
syn match   opensipsRouteBlock  "^\s*\(route\|branch_route\|failure_route\|onreply_route\|error_route\|local_route\|startup_route\|timer_route\|event_route\)\s*\(\[[-a-zA-Z0-9_:,]*\]\)\?\s*{"

" =============================================================================
" Module Loading
" =============================================================================
syn keyword opensipsModuleLoad  loadmodule modparam mpath

" =============================================================================
" Control Flow
" =============================================================================
syn keyword opensipsConditional if else switch case default
syn keyword opensipsRepeat      while for
syn keyword opensipsStatement   break return exit drop

" =============================================================================
" Global Parameters
" =============================================================================
syn keyword opensipsGlobalParam debug fork log_stderror log_facility log_name
syn keyword opensipsGlobalParam children listen alias advertised_address advertised_port
syn keyword opensipsGlobalParam disable_tcp disable_tls tcp_children tcp_accept_aliases
syn keyword opensipsGlobalParam tcp_send_timeout tcp_connect_timeout tcp_max_connections
syn keyword opensipsGlobalParam tls_verify_server tls_verify_client tls_require_client_certificate
syn keyword opensipsGlobalParam tls_method tls_certificate tls_private_key tls_ca_list
syn keyword opensipsGlobalParam server_header server_signature user group
syn keyword opensipsGlobalParam chroot workdir mhomed disable_dns_failover disable_dns_blacklist
syn keyword opensipsGlobalParam dns_try_ipv6 dns_try_naptr dns_retr_time dns_retr_no
syn keyword opensipsGlobalParam dns_servers_no dns_use_search_list max_while_loops
syn keyword opensipsGlobalParam disable_stateless_fwd db_version_table db_default_url
syn keyword opensipsGlobalParam socket auto_aliases mpath
" Additional/newer parameters
syn keyword opensipsGlobalParam log_level xlog_level stderror_enabled syslog_enabled
syn keyword opensipsGlobalParam syslog_facility udp_workers tcp_workers
syn keyword opensipsGlobalParam mem_warming mem_warming_percentage
syn keyword opensipsGlobalParam open_files_limit

" =============================================================================
" SIP Methods - Light blue for better visibility
" =============================================================================
syn keyword opensipsSIPMethod   INVITE ACK CANCEL BYE REGISTER OPTIONS PRACK UPDATE
syn keyword opensipsSIPMethod   SUBSCRIBE NOTIFY PUBLISH MESSAGE INFO REFER

" =============================================================================
" Core Functions
" =============================================================================
" Message handling
syn keyword opensipsFunction    forward forward_tcp forward_udp forward_tls send send_tcp

" Reply functions
syn keyword opensipsFunction    sl_send_reply sl_reply send_reply reply sl_reply_error

" Logging
syn keyword opensipsFunction    log xlog xdbg xinfo xnotice xwarn xerr xcrit xalert

" URI manipulation
syn keyword opensipsFunction    rewriteuri seturi sethost setport setuser sethostport
syn keyword opensipsFunction    rewritehost rewriteport rewriteuser rewriteuserpass
syn keyword opensipsFunction    setdsturi resetdsturi isdsturiset revert_uri
syn keyword opensipsFunction    strip strip_tail prefix

" Header manipulation
syn keyword opensipsFunction    append_hf append_to_reply insert_hf remove_hf is_present_hf
syn keyword opensipsFunction    append_urihf is_method has_body is_privacy

" String functions
syn keyword opensipsFunction    strlen strempty substr

" Branch handling
syn keyword opensipsFunction    append_branch clear_branches next_branches serialize_branches

" Flag functions
syn keyword opensipsFunction    setflag resetflag isflagset setbflag resetbflag isbflagset

" AVP functions
syn keyword opensipsFunction    avp_check avp_copy avp_delete avp_printf avp_pushto avp_subst

" Dialog functions
syn keyword opensipsFunction    dlg_set_timeout dlg_reset_timeout create_dialog

" NAT functions
syn keyword opensipsFunction    nat_uac_test fix_nated_contact fix_nated_sdp force_rport
syn keyword opensipsFunction    add_rcv_param fix_nated_register add_local_rport

" RTP functions
syn keyword opensipsFunction    rtpproxy_offer rtpproxy_answer rtpproxy_manage
syn keyword opensipsFunction    rtpengine_offer rtpengine_answer rtpengine_manage

" Record-Route functions
syn keyword opensipsFunction    record_route record_route_preset loose_route is_myself

" Registrar functions
syn keyword opensipsFunction    save lookup registered is_registered

" Transaction functions
syn keyword opensipsFunction    t_relay t_on_reply t_on_failure t_on_branch t_check_trans
syn keyword opensipsFunction    t_newtran t_reply t_check_status t_was_cancelled

" Max forwards
syn keyword opensipsFunction    mf_process_maxfwd_header is_maxfwd_lt process_maxfwd

" Authentication
syn keyword opensipsFunction    www_authorize proxy_authorize www_challenge proxy_challenge
syn keyword opensipsFunction    consume_credentials is_rpid_user_e164

" Dispatcher functions
syn keyword opensipsFunction    ds_select_dst ds_select_domain ds_next_dst ds_next_domain
syn keyword opensipsFunction    ds_mark_dst ds_is_in_list

" Load balancer functions
syn keyword opensipsFunction    lb_start lb_next lb_disable_dst lb_is_destination

" Permissions
syn keyword opensipsFunction    allow_routing allow_register allow_uri check_address

" Domain
syn keyword opensipsFunction    is_from_local is_uri_host_local

" Group
syn keyword opensipsFunction    is_user_in

" Textops
syn keyword opensipsFunction    search search_body search_append search_append_body
syn keyword opensipsFunction    replace replace_all replace_body replace_body_all
syn keyword opensipsFunction    subst subst_uri subst_user subst_body

" SIP message operations
syn keyword opensipsFunction    is_audio_on_hold has_totag is_request is_reply
syn keyword opensipsFunction    is_gruu is_supported is_first_hop

" Accounting functions
syn keyword opensipsFunction    do_accounting acc_log_request acc_db_request
syn keyword opensipsFunction    acc_evi_request acc_new_leg

" Cache functions
syn keyword opensipsFunction    cache_store cache_fetch cache_remove

" Other core functions
syn keyword opensipsFunction    assert force_send_socket pv_printf construct_uri
syn keyword opensipsFunction    get_timestamp raise_event script_trace

" =============================================================================
" Modules (commonly used)
" =============================================================================
syn keyword opensipsModule      acc alias_db auth auth_db avpops b2b_entities b2b_logic
syn keyword opensipsModule      benchmark cachedb_local cachedb_redis call_center cfgutils
syn keyword opensipsModule      clusterer cpl_c db_mysql db_postgres db_sqlite dialog
syn keyword opensipsModule      dispatcher diversion domain drouting enum exec
syn keyword opensipsModule      fraud_detection freeswitch gflags group httpd imc
syn keyword opensipsModule      json jsonrpc load_balancer maxfwd mediaproxy mi_fifo
syn keyword opensipsModule      mi_http mi_json msilo nat_traversal nathelper options
syn keyword opensipsModule      path permissions pike presence proto_tcp proto_tls
syn keyword opensipsModule      proto_udp proto_ws proto_wss pua qos ratelimit
syn keyword opensipsModule      registrar rest_client rls rr rtpengine rtpproxy
syn keyword opensipsModule      script_helper seas signaling sipcapture sipmsgops
syn keyword opensipsModule      siptrace sl sms snmpstats speeddial sql_cacher
syn keyword opensipsModule      sst statistics stun textops tls_mgm tm topology_hiding
syn keyword opensipsModule      uac uac_auth uac_redirect uac_registrant uri usrloc
syn keyword opensipsModule      xcap xcap_client xlog

" =============================================================================
" Boolean and Special Values
" =============================================================================
syn keyword opensipsBoolean     yes no true false
syn keyword opensipsConstant    null NULL NONE

" =============================================================================
" Operators
" =============================================================================
syn match   opensipsOperator    "==\|!=\|=\~\|!\~\|>=\|<=\|>\|<"
syn match   opensipsOperator    "&&\|||"
syn match   opensipsOperator    "!\|+\|-\|\*\|/\|%"
syn keyword opensipsOperator    and or not

" =============================================================================
" Include/Import
" =============================================================================
syn keyword opensipsInclude     include_file import_file

" =============================================================================
" Comments (defined last for highest priority)
" =============================================================================
syn keyword opensipsTodo        contained TODO FIXME XXX NOTE HACK BUG
syn match   opensipsLineComment     "#.*$" contains=opensipsTodo
syn match   opensipsLineComment     "//.*$" contains=opensipsTodo
syn region  opensipsBlockComment    start="/\*" end="\*/" contains=opensipsTodo keepend extend fold

" Sync for multi-line comments - look back to find /* start
syn sync ccomment opensipsBlockComment

" =============================================================================
" Highlighting Links
" =============================================================================
hi def link opensipsLineComment     Comment
hi def link opensipsBlockComment    Comment
hi def link opensipsComment         Comment
hi def link opensipsTodo            Todo
hi def link opensipsString          String
hi def link opensipsNumber          Number
hi def link opensipsVariable        Identifier
hi def link opensipsRouteName       Label
hi def link opensipsModuleLoad      PreProc
hi def link opensipsConditional     Conditional
hi def link opensipsRepeat          Repeat
hi def link opensipsStatement       Statement
hi def link opensipsGlobalParam     Type
hi def link opensipsFunction        Function
hi def link opensipsModule          Include
hi def link opensipsBoolean         Boolean
hi def link opensipsConstant        Constant
hi def link opensipsOperator        Operator
hi def link opensipsInclude         Include

" =============================================================================
" Custom Highlights with Specific Colors
" =============================================================================

" Route definitions - dark red color (DarkRed / #8B0000)
hi opensipsRouteType    ctermfg=DarkRed guifg=#8B0000 cterm=bold gui=bold
hi opensipsRouteBlock   ctermfg=DarkRed guifg=#8B0000 cterm=bold gui=bold

" SIP Methods - Light blue (#5FAFFF / LightSkyBlue)
" These are the request types: INVITE, ACK, CANCEL, BYE, REGISTER, etc.
hi opensipsSIPMethod    ctermfg=117 guifg=#87D7FF cterm=bold gui=bold

" SIP Methods inside strings - same light blue
hi opensipsStringMethod ctermfg=117 guifg=#87D7FF cterm=bold gui=bold

" Core Variables - Brown/Orange (#D7875F / tan/sienna)
" These are pseudo-variables like $ru, $fu, $si, $avp(), $var(), etc.
hi opensipsCoreVar      ctermfg=173 guifg=#D7875F

" Variables inside strings - same brown/orange color
hi opensipsStringVar    ctermfg=173 guifg=#D7875F

let b:current_syntax = "opensips"
