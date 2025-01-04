/* This is an automatically generated file
* @name Hello world
* @kind path-problem
* @problem.severity error
* @precision high
* @id java/example/hello-world
*/

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSinks
 // import semmle.code.java.dataflow.DataFlow
 import semmle.code.java.dataflow.TaintTracking //TaintTracking
 // import codeql.dataflow.DataFlow //PathGraph

predicate stringSet(string s) {
  s = "adl.feature.ownerandgroup.enableupn" or
  s = "adl.http.timeout" or
  s = "adl.ssl.channel.mode" or
  s = "dfs.client.ignore.namenode.default.kms.uri" or
  s = "dfs.ha.fencing.methods" or
  s = "dfs.ha.fencing.ssh.connect-timeout" or
  s = "dfs.ha.fencing.ssh.private-key-files" or
  s = "file.blocksize" or
  s = "file.bytes-per-checksum" or
  s = "file.client-write-packet-size" or
  s = "file.replication" or
  s = "file.stream-buffer-size" or
  s = "fs.AbstractFileSystem.abfs.impl" or
  s = "fs.AbstractFileSystem.abfss.impl" or
  s = "fs.AbstractFileSystem.adl.impl" or
  s = "fs.AbstractFileSystem.file.impl" or
  s = "fs.AbstractFileSystem.ftp.impl" or
  s = "fs.AbstractFileSystem.gs.impl" or
  s = "fs.AbstractFileSystem.har.impl" or
  s = "fs.AbstractFileSystem.hdfs.impl" or
  s = "fs.AbstractFileSystem.o3fs.impl" or
  s = "fs.AbstractFileSystem.ofs.impl" or
  s = "fs.AbstractFileSystem.s3a.impl" or
  s = "fs.AbstractFileSystem.swebhdfs.impl" or
  s = "fs.AbstractFileSystem.viewfs.impl" or
  s = "fs.AbstractFileSystem.wasb.impl" or
  s = "fs.AbstractFileSystem.wasbs.impl" or
  s = "fs.AbstractFileSystem.webhdfs.impl" or
  s = "fs.abfs.impl" or
  s = "fs.abfss.impl" or
  s = "fs.adl.impl" or
  s = "fs.adl.oauth2.access.token.provider" or
  s = "fs.adl.oauth2.access.token.provider.type" or
  s = "fs.adl.oauth2.client.id" or
  s = "fs.adl.oauth2.credential" or
  s = "fs.adl.oauth2.devicecode.clientapp.id" or
  s = "fs.adl.oauth2.msi.port" or
  s = "fs.adl.oauth2.refresh.token" or
  s = "fs.adl.oauth2.refresh.url" or
  s = "fs.automatic.close" or
  s = "fs.azure.authorization" or
  s = "fs.azure.authorization.caching.enable" or
  s = "fs.azure.buffer.dir" or
  s = "fs.azure.enable.readahead" or
  s = "fs.azure.local.sas.key.mode" or
  s = "fs.azure.sas.expiry.period" or
  s = "fs.azure.saskey.usecontainersaskeyforallaccess" or
  s = "fs.azure.secure.mode" or
  s = "fs.azure.user.agent.prefix" or
  s = "fs.client.htrace.sampler.classes" or
  s = "fs.client.resolve.remote.symlinks" or
  s = "fs.client.resolve.topology.enabled" or
  s = "fs.creation.parallel.count" or
  s = "fs.default.name" or
  s = "fs.defaultFS" or
  s = "fs.df.interval" or
  s = "fs.du.interval" or
  s = "fs.file.impl" or
  s = "fs.ftp.data.connection.mode" or
  s = "fs.ftp.host" or
  s = "fs.ftp.host.port" or
  s = "fs.ftp.impl" or
  s = "fs.ftp.timeout" or
  s = "fs.ftp.transfer.mode" or
  s = "fs.getspaceused.classname" or
  s = "fs.getspaceused.jitterMillis" or
  s = "fs.har.impl.disable.cache" or
  s = "fs.iostatistics.logging.level" or
  s = "fs.iostatistics.thread.level.enabled" or
  s = "fs.permissions.umask-mode" or
  s = "fs.protected.directories" or
  s = "fs.s3a.access.key" or
  s = "fs.s3a.accesspoint.required" or
  s = "fs.s3a.acl.default" or
  s = "fs.s3a.assumed.role.arn" or
  s = "fs.s3a.assumed.role.credentials.provider" or
  s = "fs.s3a.assumed.role.policy" or
  s = "fs.s3a.assumed.role.session.duration" or
  s = "fs.s3a.assumed.role.session.name" or
  s = "fs.s3a.assumed.role.sts.endpoint" or
  s = "fs.s3a.assumed.role.sts.endpoint.region" or
  s = "fs.s3a.attempts.maximum" or
  s = "fs.s3a.audit.enabled" or
  s = "fs.s3a.aws.credentials.provider" or
  s = "fs.s3a.block.size" or
  s = "fs.s3a.buffer.dir" or
  s = "fs.s3a.change.detection.mode" or
  s = "fs.s3a.change.detection.source" or
  s = "fs.s3a.change.detection.version.required" or
  s = "fs.s3a.committer.abort.pending.uploads" or
  s = "fs.s3a.committer.magic.enabled" or
  s = "fs.s3a.committer.name" or
  s = "fs.s3a.committer.staging.conflict-mode" or
  s = "fs.s3a.committer.staging.tmp.path" or
  s = "fs.s3a.committer.staging.unique-filenames" or
  s = "fs.s3a.committer.threads" or
  s = "fs.s3a.connection.establish.timeout" or
  s = "fs.s3a.connection.maximum" or
  s = "fs.s3a.connection.ssl.enabled" or
  s = "fs.s3a.connection.timeout" or
  s = "fs.s3a.connection.ttl" or
  s = "fs.s3a.delegation.token.binding" or
  s = "fs.s3a.downgrade.syncable.exceptions" or
  s = "fs.s3a.encryption.algorithm" or
  s = "fs.s3a.encryption.context" or
  s = "fs.s3a.encryption.key" or
  s = "fs.s3a.endpoint" or
  s = "fs.s3a.etag.checksum.enabled" or
  s = "fs.s3a.executor.capacity" or
  s = "fs.s3a.fast.upload.active.blocks" or
  s = "fs.s3a.fast.upload.buffer" or
  s = "fs.s3a.impl" or
  s = "fs.s3a.list.version" or
  s = "fs.s3a.max.total.tasks" or
  s = "fs.s3a.multiobjectdelete.enable" or
  s = "fs.s3a.multipart.purge" or
  s = "fs.s3a.multipart.purge.age" or
  s = "fs.s3a.multipart.size" or
  s = "fs.s3a.multipart.threshold" or
  s = "fs.s3a.paging.maximum" or
  s = "fs.s3a.path.style.access" or
  s = "fs.s3a.proxy.domain" or
  s = "fs.s3a.proxy.host" or
  s = "fs.s3a.proxy.password" or
  s = "fs.s3a.proxy.port" or
  s = "fs.s3a.proxy.username" or
  s = "fs.s3a.proxy.workstation" or
  s = "fs.s3a.readahead.range" or
  s = "fs.s3a.retry.interval" or
  s = "fs.s3a.retry.limit" or
  s = "fs.s3a.retry.throttle.interval" or
  s = "fs.s3a.retry.throttle.limit" or
  s = "fs.s3a.secret.key" or
  s = "fs.s3a.security.credential.provider.path" or
  s = "fs.s3a.select.enabled" or
  s = "fs.s3a.select.errors.include.sql" or
  s = "fs.s3a.select.input.compression" or
  s = "fs.s3a.select.input.csv.comment.marker" or
  s = "fs.s3a.select.input.csv.field.delimiter" or
  s = "fs.s3a.select.input.csv.header" or
  s = "fs.s3a.select.input.csv.quote.character" or
  s = "fs.s3a.select.input.csv.quote.escape.character" or
  s = "fs.s3a.select.input.csv.record.delimiter" or
  s = "fs.s3a.select.output.csv.field.delimiter" or
  s = "fs.s3a.select.output.csv.quote.character" or
  s = "fs.s3a.select.output.csv.quote.escape.character" or
  s = "fs.s3a.select.output.csv.quote.fields" or
  s = "fs.s3a.select.output.csv.record.delimiter" or
  s = "fs.s3a.session.token" or
  s = "fs.s3a.signing-algorithm" or
  s = "fs.s3a.socket.recv.buffer" or
  s = "fs.s3a.socket.send.buffer" or
  s = "fs.s3a.ssl.channel.mode" or
  s = "fs.s3a.threads.keepalivetime" or
  s = "fs.s3a.threads.max" or
  s = "fs.s3a.user.agent.prefix" or
  s = "fs.trash.checkpoint.interval" or
  s = "fs.trash.clean.trashroot.enable" or
  s = "fs.trash.interval" or
  s = "fs.viewfs.overload.scheme.target.abfs.impl" or
  s = "fs.viewfs.overload.scheme.target.abfss.impl" or
  s = "fs.viewfs.overload.scheme.target.file.impl" or
  s = "fs.viewfs.overload.scheme.target.ftp.impl" or
  s = "fs.viewfs.overload.scheme.target.gs.impl" or
  s = "fs.viewfs.overload.scheme.target.hdfs.impl" or
  s = "fs.viewfs.overload.scheme.target.http.impl" or
  s = "fs.viewfs.overload.scheme.target.https.impl" or
  s = "fs.viewfs.overload.scheme.target.o3fs.impl" or
  s = "fs.viewfs.overload.scheme.target.ofs.impl" or
  s = "fs.viewfs.overload.scheme.target.oss.impl" or
  s = "fs.viewfs.overload.scheme.target.s3a.impl" or
  s = "fs.viewfs.overload.scheme.target.swebhdfs.impl" or
  s = "fs.viewfs.overload.scheme.target.wasb.impl" or
  s = "fs.viewfs.overload.scheme.target.webhdfs.impl" or
  s = "fs.viewfs.rename.strategy" or
  s = "fs.wasb.impl" or
  s = "fs.wasbs.impl" or
  s = "ftp.blocksize" or
  s = "ftp.bytes-per-checksum" or
  s = "ftp.client-write-packet-size" or
  s = "ftp.replication" or
  s = "ftp.stream-buffer-size" or
  s = "ha.failover-controller.active-standby-elector.zk.op.retries" or
  s = "ha.failover-controller.cli-check.rpc-timeout.ms" or
  s = "ha.failover-controller.graceful-fence.connection.retries" or
  s = "ha.failover-controller.graceful-fence.rpc-timeout.ms" or
  s = "ha.failover-controller.new-active.rpc-timeout.ms" or
  s = "ha.health-monitor.check-interval.ms" or
  s = "ha.health-monitor.connect-retry-interval.ms" or
  s = "ha.health-monitor.rpc-timeout.ms" or
  s = "ha.health-monitor.rpc.connect.max.retries" or
  s = "ha.health-monitor.sleep-after-disconnect.ms" or
  s = "ha.zookeeper.acl" or
  s = "ha.zookeeper.auth" or
  s = "ha.zookeeper.parent-znode" or
  s = "ha.zookeeper.quorum" or
  s = "ha.zookeeper.session-timeout.ms" or
  s = "hadoop.caller.context.enabled" or
  s = "hadoop.caller.context.max.size" or
  s = "hadoop.caller.context.separator" or
  s = "hadoop.caller.context.signature.max.size" or
  s = "hadoop.common.configuration.version" or
  s = "hadoop.domainname.resolver.impl" or
  s = "hadoop.htrace.span.receiver.classes" or
  s = "hadoop.http.authentication.cookie.domain" or
  s = "hadoop.http.authentication.kerberos.endpoint.whitelist" or
  s = "hadoop.http.authentication.kerberos.keytab" or
  s = "hadoop.http.authentication.kerberos.principal" or
  s = "hadoop.http.authentication.signature.secret.file" or
  s = "hadoop.http.authentication.simple.anonymous.allowed" or
  s = "hadoop.http.authentication.token.validity" or
  s = "hadoop.http.authentication.type" or
  s = "hadoop.http.cross-origin.allowed-headers" or
  s = "hadoop.http.cross-origin.allowed-methods" or
  s = "hadoop.http.cross-origin.allowed-origins" or
  s = "hadoop.http.cross-origin.enabled" or
  s = "hadoop.http.cross-origin.max-age" or
  s = "hadoop.http.filter.initializers" or
  s = "hadoop.http.idle_timeout.ms" or
  s = "hadoop.http.jmx.nan-filter.enabled" or
  s = "hadoop.http.logs.enabled" or
  s = "hadoop.http.metrics.enabled" or
  s = "hadoop.http.sni.host.check.enabled" or
  s = "hadoop.http.staticuser.user" or
  s = "hadoop.jetty.logs.serve.aliases" or
  s = "hadoop.kerberos.keytab.login.autorenewal.enabled" or
  s = "hadoop.kerberos.kinit.command" or
  s = "hadoop.kerberos.min.seconds.before.relogin" or
  s = "hadoop.metrics.jvm.use-thread-mxbean" or
  s = "hadoop.prometheus.endpoint.enabled" or
  s = "hadoop.registry.jaas.context" or
  s = "hadoop.registry.kerberos.realm" or
  s = "hadoop.registry.secure" or
  s = "hadoop.registry.system.acls" or
  s = "hadoop.registry.zk.connection.timeout.ms" or
  s = "hadoop.registry.zk.quorum" or
  s = "hadoop.registry.zk.retry.ceiling.ms" or
  s = "hadoop.registry.zk.retry.interval.ms" or
  s = "hadoop.registry.zk.retry.times" or
  s = "hadoop.registry.zk.root" or
  s = "hadoop.registry.zk.session.timeout.ms" or
  s = "hadoop.rpc.protection" or
  s = "hadoop.rpc.socket.factory.class.ClientProtocol" or
  s = "hadoop.rpc.socket.factory.class.default" or
  s = "hadoop.security.auth_to_local" or
  s = "hadoop.security.auth_to_local.mechanism" or
  s = "hadoop.security.authentication" or
  s = "hadoop.security.authorization" or
  s = "hadoop.security.credential.clear-text-fallback" or
  s = "hadoop.security.credential.provider.path" or
  s = "hadoop.security.credstore.java-keystore-provider.password-file" or
  s = "hadoop.security.crypto.buffer.size" or
  s = "hadoop.security.crypto.cipher.suite" or
  s = "hadoop.security.crypto.codec.classes.EXAMPLECIPHERSUITE" or
  s = "hadoop.security.crypto.codec.classes.aes.ctr.nopadding" or
  s = "hadoop.security.crypto.codec.classes.sm4.ctr.nopadding" or
  s = "hadoop.security.crypto.jce.provider" or
  s = "hadoop.security.crypto.jce.provider.auto-add" or
  s = "hadoop.security.crypto.jceks.key.serialfilter" or
  s = "hadoop.security.dns.interface" or
  s = "hadoop.security.dns.log-slow-lookups.enabled" or
  s = "hadoop.security.dns.log-slow-lookups.threshold.ms" or
  s = "hadoop.security.dns.nameserver" or
  s = "hadoop.security.group.mapping" or
  s = "hadoop.security.group.mapping.ldap.base" or
  s = "hadoop.security.group.mapping.ldap.bind.password" or
  s = "hadoop.security.group.mapping.ldap.bind.password.alias" or
  s = "hadoop.security.group.mapping.ldap.bind.password.file" or
  s = "hadoop.security.group.mapping.ldap.bind.user" or
  s = "hadoop.security.group.mapping.ldap.bind.users" or
  s = "hadoop.security.group.mapping.ldap.connection.timeout.ms" or
  s = "hadoop.security.group.mapping.ldap.conversion.rule" or
  s = "hadoop.security.group.mapping.ldap.ctx.factory.class" or
  s = "hadoop.security.group.mapping.ldap.directory.search.timeout" or
  s = "hadoop.security.group.mapping.ldap.group.search.filter.pattern" or
  s = "hadoop.security.group.mapping.ldap.groupbase" or
  s = "hadoop.security.group.mapping.ldap.num.attempts" or
  s = "hadoop.security.group.mapping.ldap.num.attempts.before.failover" or
  s = "hadoop.security.group.mapping.ldap.posix.attr.gid.name" or
  s = "hadoop.security.group.mapping.ldap.posix.attr.uid.name" or
  s = "hadoop.security.group.mapping.ldap.read.timeout.ms" or
  s = "hadoop.security.group.mapping.ldap.search.attr.group.name" or
  s = "hadoop.security.group.mapping.ldap.search.attr.member" or
  s = "hadoop.security.group.mapping.ldap.search.attr.memberof" or
  s = "hadoop.security.group.mapping.ldap.search.filter.group" or
  s = "hadoop.security.group.mapping.ldap.search.filter.user" or
  s = "hadoop.security.group.mapping.ldap.search.group.hierarchy.levels" or
  s = "hadoop.security.group.mapping.ldap.ssl" or
  s = "hadoop.security.group.mapping.ldap.ssl.keystore" or
  s = "hadoop.security.group.mapping.ldap.ssl.keystore.password" or
  s = "hadoop.security.group.mapping.ldap.ssl.keystore.password.file" or
  s = "hadoop.security.group.mapping.ldap.ssl.truststore" or
  s = "hadoop.security.group.mapping.ldap.ssl.truststore.password.file" or
  s = "hadoop.security.group.mapping.ldap.url" or
  s = "hadoop.security.group.mapping.ldap.userbase" or
  s = "hadoop.security.group.mapping.providers" or
  s = "hadoop.security.group.mapping.providers.combined" or
  s = "hadoop.security.groups.cache.background.reload" or
  s = "hadoop.security.groups.cache.background.reload.threads" or
  s = "hadoop.security.groups.cache.secs" or
  s = "hadoop.security.groups.cache.warn.after.ms" or
  s = "hadoop.security.groups.negative-cache.secs" or
  s = "hadoop.security.groups.shell.command.timeout" or
  s = "hadoop.security.impersonation.provider.class" or
  s = "hadoop.security.instrumentation.requires.admin" or
  s = "hadoop.security.java.secure.random.algorithm" or
  s = "hadoop.security.kerberos.ticket.cache.path" or
  s = "hadoop.security.key.default.bitlength" or
  s = "hadoop.security.key.default.cipher" or
  s = "hadoop.security.key.provider.path" or
  s = "hadoop.security.kms.client.authentication.retry-count" or
  s = "hadoop.security.kms.client.encrypted.key.cache.expiry" or
  s = "hadoop.security.kms.client.encrypted.key.cache.low-watermark" or
  s = "hadoop.security.kms.client.encrypted.key.cache.num.refill.threads" or
  s = "hadoop.security.kms.client.encrypted.key.cache.size" or
  s = "hadoop.security.kms.client.failover.max.retries" or
  s = "hadoop.security.kms.client.failover.sleep.base.millis" or
  s = "hadoop.security.kms.client.failover.sleep.max.millis" or
  s = "hadoop.security.kms.client.timeout" or
  s = "hadoop.security.openssl.engine.id" or
  s = "hadoop.security.random.device.file.path" or
  s = "hadoop.security.resolver.impl" or
  s = "hadoop.security.saslproperties.resolver.class" or
  s = "hadoop.security.secure.random.impl" or
  s = "hadoop.security.sensitive-config-keys" or
  s = "hadoop.security.service.user.name.key" or
  s = "hadoop.security.token.service.use_ip" or
  s = "hadoop.security.uid.cache.secs" or
  s = "hadoop.service.shutdown.timeout" or
  s = "hadoop.shell.missing.defaultFs.warning" or
  s = "hadoop.shell.safely.delete.limit.num.files" or
  s = "hadoop.socks.server" or
  s = "hadoop.ssl.client.conf" or
  s = "hadoop.ssl.enabled.protocols" or
  s = "hadoop.ssl.hostname.verifier" or
  s = "hadoop.ssl.keystores.factory.class" or
  s = "hadoop.ssl.require.client.cert" or
  s = "hadoop.ssl.server.conf" or
  s = "hadoop.system.tags" or
  s = "hadoop.tags.custom" or
  s = "hadoop.tags.system" or
  s = "hadoop.tmp.dir" or
  s = "hadoop.token.files" or
  s = "hadoop.tokens" or
  s = "hadoop.user.group.metrics.percentiles.intervals" or
  s = "hadoop.user.group.static.mapping.overrides" or
  s = "hadoop.util.hash.type" or
  s = "hadoop.workaround.non.threadsafe.getpwuid" or
  s = "hadoop.zk.acl" or
  s = "hadoop.zk.address" or
  s = "hadoop.zk.auth" or
  s = "hadoop.zk.kerberos.keytab" or
  s = "hadoop.zk.kerberos.principal" or
  s = "hadoop.zk.num-retries" or
  s = "hadoop.zk.retry-interval-ms" or
  s = "hadoop.zk.server.principal" or
  s = "hadoop.zk.ssl.enabled" or
  s = "hadoop.zk.ssl.keystore.location" or
  s = "hadoop.zk.ssl.keystore.password" or
  s = "hadoop.zk.ssl.truststore.location" or
  s = "hadoop.zk.ssl.truststore.password" or
  s = "hadoop.zk.timeout-ms" or
  s = "io.bytes.per.checksum" or
  s = "io.compression.codec.bzip2.library" or
  s = "io.compression.codec.lz4.buffersize" or
  s = "io.compression.codec.lz4.use.lz4hc" or
  s = "io.compression.codec.lzo.buffersize" or
  s = "io.compression.codec.lzo.class" or
  s = "io.compression.codec.snappy.buffersize" or
  s = "io.compression.codec.zstd.buffersize" or
  s = "io.compression.codec.zstd.level" or
  s = "io.compression.codecs" or
  s = "io.erasurecode.codec.native.enabled" or
  s = "io.erasurecode.codec.rs-legacy.rawcoders" or
  s = "io.erasurecode.codec.rs.rawcoders" or
  s = "io.erasurecode.codec.xor.rawcoders" or
  s = "io.file.buffer.size" or
  s = "io.map.index.interval" or
  s = "io.map.index.skip" or
  s = "io.mapfile.bloom.error.rate" or
  s = "io.mapfile.bloom.size" or
  s = "io.seqfile.compress.blocksize" or
  s = "io.seqfile.local.dir" or
  s = "io.serializations" or
  s = "io.skip.checksum.errors" or
  s = "ipc.[port_number].backoff.enable" or
  s = "ipc.[port_number].callqueue.capacity.weights" or
  s = "ipc.[port_number].callqueue.impl" or
  s = "ipc.[port_number].callqueue.overflow.trigger.failover" or
  s = "ipc.[port_number].cost-provider.impl" or
  s = "ipc.[port_number].decay-scheduler.backoff.responsetime.enable" or
  s = "ipc.[port_number].decay-scheduler.backoff.responsetime.thresholds" or
  s = "ipc.[port_number].decay-scheduler.decay-factor" or
  s = "ipc.[port_number].decay-scheduler.metrics.top.user.count" or
  s = "ipc.[port_number].decay-scheduler.period-ms" or
  s = "ipc.[port_number].decay-scheduler.service-users" or
  s = "ipc.[port_number].decay-scheduler.thresholds" or
  s = "ipc.[port_number].faircallqueue.multiplexer.weights" or
  s = "ipc.[port_number].identity-provider.impl" or
  s = "ipc.[port_number].scheduler.impl" or
  s = "ipc.[port_number].scheduler.priority.levels" or
  s = "ipc.[port_number].weighted-cost.handler" or
  s = "ipc.[port_number].weighted-cost.lockexclusive" or
  s = "ipc.[port_number].weighted-cost.lockfree" or
  s = "ipc.[port_number].weighted-cost.lockshared" or
  s = "ipc.[port_number].weighted-cost.response" or
  s = "ipc.backoff.enable" or
  s = "ipc.callqueue.impl" or
  s = "ipc.callqueue.overflow.trigger.failover" or
  s = "ipc.client.async.calls.max" or
  s = "ipc.client.bind.wildcard.addr" or
  s = "ipc.client.connect.max.retries" or
  s = "ipc.client.connect.max.retries.on.sasl" or
  s = "ipc.client.connect.max.retries.on.timeouts" or
  s = "ipc.client.connect.retry.interval" or
  s = "ipc.client.connect.timeout" or
  s = "ipc.client.connection.idle-scan-interval.ms" or
  s = "ipc.client.connection.maxidletime" or
  s = "ipc.client.fallback-to-simple-auth-allowed" or
  s = "ipc.client.idlethreshold" or
  s = "ipc.client.kill.max" or
  s = "ipc.client.low-latency" or
  s = "ipc.client.ping" or
  s = "ipc.client.rpc-timeout.ms" or
  s = "ipc.client.tcpnodelay" or
  s = "ipc.cost-provider.impl" or
  s = "ipc.identity-provider.impl" or
  s = "ipc.maximum.data.length" or
  s = "ipc.maximum.response.length" or
  s = "ipc.ping.interval" or
  s = "ipc.scheduler.impl" or
  s = "ipc.server.handler.queue.size" or
  s = "ipc.server.listen.queue.size" or
  s = "ipc.server.log.slow.rpc" or
  s = "ipc.server.log.slow.rpc.threshold.ms" or
  s = "ipc.server.max.connections" or
  s = "ipc.server.max.response.size" or
  s = "ipc.server.metrics.update.runner.interval" or
  s = "ipc.server.purge.interval" or
  s = "ipc.server.read.connection-queue.size" or
  s = "ipc.server.read.threadpool.size" or
  s = "ipc.server.reuseaddr" or
  s = "ipc.server.tcpnodelay" or
  s = "net.topology.configured.node.mapping" or
  s = "net.topology.dependency.script.file.name" or
  s = "net.topology.impl" or
  s = "net.topology.node.switch.mapping.impl" or
  s = "net.topology.script.file.name" or
  s = "net.topology.script.number.args" or
  s = "net.topology.table.file.name" or
  s = "nfs.exports.allowed.hosts" or
  s = "rpc.metrics.percentiles.intervals" or
  s = "rpc.metrics.quantile.enable" or
  s = "rpc.metrics.timeunit" or
  s = "security.service.authorization.default.acl" or
  s = "security.service.authorization.default.acl.blocked" or
  s = "seq.io.sort.factor" or
  s = "seq.io.sort.mb" or
  s = "tfile.fs.input.buffer.size" or
  s = "tfile.fs.output.buffer.size" or
  s = "tfile.io.chunk.size"  
}

module MyFlowConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // exists(StringLiteral sl, Method m, MethodCall mc, int index |
    
    //   mc.getMethod() = m and
    //   mc.getArgument(index) = sl and
    //   stringSet(sl.getValue()) and               
    //   source.asExpr() = mc.getArgument(index)  
    // ) or 
    exists(Assignment assign, StringLiteral sl |
      stringSet(sl.getValue()) and 
      sl = assign.getRhs() and
      source.asExpr() = sl
    )
  }

  predicate isSink(DataFlow::Node sink) {
      exists(MethodCall call, int index |
        sink.asExpr() = call.getArgument(index) and
        call.getMethod().hasName("getInt") and 
        not sink.asExpr().toString().isLowercase()
      )
    }
}

module MyFlow = TaintTracking::Global<MyFlowConfiguration>;
import MyFlow::PathGraph

from MyFlow::PathNode source, MyFlow::PathNode sink
where MyFlow::flowPath(source, sink)
select
  source,
  source.getNode().asExpr().getEnclosingCallable(),
  source.getNode().getEnclosingCallable().getDeclaringType(),
  sink,
  sink.getNode().asExpr().getEnclosingCallable(),
  sink.getNode().getEnclosingCallable().getDeclaringType()