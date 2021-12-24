load(
  "//scripts/versions:versions.bzl",
  "CASSANDRA_DEB_VERSION",
  "ELASTICSEARCH_VERSION",
  "ENVOY_VERSION",
  "ERLANG_DEB_VERSION",
  "GERRIT_VERSION",
  "GRAAL_VERSION",
  "GRAFANA_VERSION",
  "JASPERREPORTS_SERVER_VERSION",
  "JENKINS_VERSION",
  "JENKINS_SWARM_VERSION",
  "KAFKA_VERSION",
  "KIBANA_VERSION",
  "NODEJS_FOR_KIBANA_VERSION",
  "MAVEN_VERSION",
  "NEXUS_VERSION",
  "NODEJS_VERSION",
  "PENATHO_DI_VERSION",
  "PROMETHEUS_VERSION",
  "PROMETHEUS_JMX_JAVAAGENT",
  "RABBITMQ_VERSION",
  "SBT_VERSION",
  "YARN_VERSION",
  "ZIPKIN_VERSION",
  "ZOOKEEPER_VERSION"
)
load("//deps/buster:buster.bzl", "deb_buster")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:maven_rules.bzl", "maven_jar")

def dependency_repositories():
  http_archive(
    name = "bazel_rules_container_test",
    sha256 = "0ea03839bf059c0ec7c4f95cb6cb048b84094b180b051c737cbef9ca150bcc0b",
    strip_prefix = "bazel_rules_container_test-0.11.0",
    url = "https://github.com/guymers/bazel_rules_container/archive/0.11.0.tar.gz",
  )

  # Update to 20211220 for amd64 (debuerreotype 0.13)
  http_file(
    name = "debian_buster",
    downloaded_file_path = "buster-slim-rootfs.tar.xz",
    urls = ["https://raw.githubusercontent.com/debuerreotype/docker-debian-artifacts/d5eb7c589d016973bce6f3e1827b5c315b7cefbc/buster/slim/rootfs.tar.xz"],
    sha256 = "532c2235d13be8abc5fa550860c11694a2a9e2d4b9e85dec23e4d904f5ba00de",
  )
  deb_buster()

  http_archive(
    name = "su_exec",
    url = "https://github.com/ncopa/su-exec/archive/v0.2.tar.gz",
    sha256 = "ec4acbd8cde6ceeb2be67eda1f46c709758af6db35cacbcde41baac349855e25",
    strip_prefix = "su-exec-0.2",
    build_file_content = "cc_binary( \
      name = 'su_exec', \
      srcs = ['su-exec.c'], \
      visibility = ['//visibility:public'], \
    )",
  )

  http_file(
    name = "tini",
    downloaded_file_path = "tini.deb",
    urls = ["https://github.com/krallin/tini/releases/download/v0.19.0/tini_0.19.0-amd64.deb"],
    sha256 = "c52945a4fc24d3680253beb2b29bbb8fe62712817f4109e8fcd347fe611fd41c",
  )

  ###### GRAAL
  [
    http_archive(
      name = "graal_" + v,
      url = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-" + GRAAL_VERSION + "/graalvm-ce-java" + v + "-linux-amd64-" + GRAAL_VERSION + ".tar.gz",
      sha256 = sha,
      build_file_content = "exports_files(['graalvm-ce-java" + v + "-" + GRAAL_VERSION + "'])",
    ) for (v, sha) in [
      ("11", "3a1bc8eaf0518c128aaacb987ceb0b0e288776f48af630c11c01fd31122d93fa"),
      ("17", "11d8039e0a7a31b799a6f20a0e806e4128730e9a2595a7ffdec1443539d4c3f6"),
    ]
  ]

  ###### CASSANDRA
  http_file(
    name = "cassandra",
    downloaded_file_path = "cassandra.deb",
    urls = ["https://downloads.apache.org/cassandra/debian/pool/main/c/cassandra/cassandra_" + CASSANDRA_DEB_VERSION + ".deb"],
    sha256 = "2066390530c8084790e3463f35f61943f4fb606595e7729640561ed2f60afcf1",
  )
  http_file(
    name = "cassandra_tools",
    downloaded_file_path = "cassandra-tools.deb",
    urls = ["https://downloads.apache.org/cassandra/debian/pool/main/c/cassandra/cassandra-tools_" + CASSANDRA_DEB_VERSION + ".deb"],
    sha256 = "56d395fe3f0dc23536eba8ee7ae79e3745ebb6c740aadb234d5540737635d258",
  )

  ###### ELASTICSEARCH
  http_file(
    name = "elasticsearch",
    downloaded_file_path = "elasticsearch.deb",
    urls = ["https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-" + ELASTICSEARCH_VERSION + "-amd64.deb"],
    sha256 = "570af7456603fd103408ed61ccec4473302976d46e1ff845b74a881122977e02",
  )

  ###### ENVOY
  http_archive(
    name = "envoy",
    urls = ["https://github.com/tetratelabs/archive-envoy/releases/download/v" + ENVOY_VERSION + "/envoy-v" + ENVOY_VERSION + "-linux-amd64.tar.xz"],
    sha256 = "227c6166d4fb73e6d8ef8976549536a50fa9e5b0fdc6984190524d829a33b9b2",
    build_file_content = "exports_files(['envoy-v" + ENVOY_VERSION + "-linux-amd64'])",
  )

  ###### ERLANG
  http_file(
    name = "erlang",
    downloaded_file_path = "erlang.deb",
    urls = ["https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_" + ERLANG_DEB_VERSION + "~debian~buster_amd64.deb"],
    sha256 = "f55fd3e12e375f958322f9ede1dda267346ab91cae371c4db6662ec85c628e74",
  )

  ###### GERRIT
  http_file(
    name = "gerrit_war",
    downloaded_file_path = "gerrit.war",
    urls = ["https://gerrit-releases.storage.googleapis.com/gerrit-" + GERRIT_VERSION + ".war"],
    sha256 = "4d264c0d6bc3ecde24f932cf99b41fddd8dbd53f0e711dcb10a133a4c595f80d",
  )

  ###### GRAFANA
  http_file(
    name = "grafana",
    downloaded_file_path = "grafana.deb",
    urls = ["https://dl.grafana.com/oss/release/grafana_" + GRAFANA_VERSION + "_amd64.deb"],
    sha256 = "44be296a2656f737aedda4674e97ab2066996ef00c52526d373bd556ae82bb46",
  )

  ###### JENKINS
  http_file(
    name = "jenkins_war",
    downloaded_file_path = "jenkins.war",
    urls = ["https://get.jenkins.io/war-stable/" + JENKINS_VERSION + "/jenkins.war"],
    sha256 = "7e4b848a752eda740c2c7a60956bf05d9df42602c805bbaeac897179b630a562",
  )
  http_file(
    name = "jenkins_agent_jar",
    downloaded_file_path = "swarm-client.war",
    urls = ["http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/" + JENKINS_SWARM_VERSION + "/swarm-client-" + JENKINS_SWARM_VERSION + ".jar"],
    sha256 = "2b7dd9d7c0fe752984d1b880c65b96ea825be4d5377d046fe91ab4ad4218f733",
  )

  ###### KIBANA
  http_file(
    name = "kibana",
    downloaded_file_path = "kibana.deb",
    urls = ["https://artifacts.elastic.co/downloads/kibana/kibana-" + KIBANA_VERSION + "-amd64.deb"],
    sha256 = "24b470d6cd5e846f7c7fea89bfeabe4fef045237b7887b438339ad4cb54e8320",
  )

  http_file(
    name = "nodejs_for_kibana",
    downloaded_file_path = "nodejs.tar.xz",
    urls = ["https://nodejs.org/dist/v" + NODEJS_FOR_KIBANA_VERSION + "/node-v" + NODEJS_FOR_KIBANA_VERSION + "-linux-x64.tar.xz"],
    sha256 = "c10eece562cfeef1627f0d2bde7dc0be810948f6bf9a932e30a8c3b425652015"
  )

  ###### KAFKA
  http_archive(
    name = "kafka",
    url = "https://archive.apache.org/dist/kafka/" + KAFKA_VERSION + "/kafka_2.13-" + KAFKA_VERSION + ".tgz",
    sha256 = "4888b03e3b27dd94f2d830ce3bae9d7d98b0ccee3a5d30c919ccb60e0fa1f139",
    build_file_content = "exports_files(['kafka_2.13-" + KAFKA_VERSION + "'])",
  )

  ###### MAVEN
  http_archive(
    name = "maven",
    url = "https://archive.apache.org/dist/maven/maven-3/" + MAVEN_VERSION + "/binaries/apache-maven-" + MAVEN_VERSION + "-bin.tar.gz",
    sha256 = "2cdc9c519427bb20fdc25bef5a9063b790e4abd930e7b14b4e9f4863d6f9f13c",
    build_file_content = "exports_files(['apache-maven-" + MAVEN_VERSION + "'])",
  )

  ###### NEXUS
  http_archive(
    name = "nexus",
    url = "https://download.sonatype.com/nexus/oss/nexus-" + NEXUS_VERSION + "-bundle.tar.gz",
    sha256 = "0d09b35265b06e0f1ecadb00f31d0f7e187a35b39fc34d762c0393918ccf19c8",
    build_file_content = "exports_files(['nexus-" + NEXUS_VERSION + "'])",
  )

  ###### NODEJS
  http_file(
    name = "nodejs",
    downloaded_file_path = "nodejs.tar.xz",
    urls = ["https://nodejs.org/dist/v" + NODEJS_VERSION + "/node-v" + NODEJS_VERSION + "-linux-x64.tar.xz"],
    sha256 = "a3721f87cecc0b52b0be8587c20776ac7305db413751db02c55aa2bffac15198"
  )

  ###### PROMETHEUS
  http_archive(
    name = "prometheus",
    url = "https://github.com/prometheus/prometheus/releases/download/v" + PROMETHEUS_VERSION + "/prometheus-" + PROMETHEUS_VERSION + ".linux-amd64.tar.gz",
    sha256 = "f08e96d73330a9ee7e6922a9f5b72ea188988a083bbfa9932359339fcf504a74",
    strip_prefix = "prometheus-" + PROMETHEUS_VERSION + ".linux-amd64",
    build_file_content = "exports_files(['prometheus'])",
  )

  maven_jar(
    name = "jmx_prometheus_javaagent",
    artifact = "io.prometheus.jmx:jmx_prometheus_javaagent:" + PROMETHEUS_JMX_JAVAAGENT,
    sha1 = "d3952d71a19007372240657b07f5b1b42994880e",
  )

  ###### RABBITMQ
  http_file(
    name = "rabbitmq",
    downloaded_file_path = "rabbitmq.deb",
    urls = ["https://github.com/rabbitmq/rabbitmq-server/releases/download/v" + RABBITMQ_VERSION + "/rabbitmq-server_" + RABBITMQ_VERSION + "-1_all.deb"],
    sha256 = "19f9dd7f465100ef112645fe3855d71ed944829a6bc38f5f0a916bd015308af9",
  )

  ###### SBT
  http_archive(
    name = "sbt",
    url = "https://github.com/sbt/sbt/releases/download/v" + SBT_VERSION + "/sbt-" + SBT_VERSION + ".tgz",
    sha256 = "d7490840dcbedd5d520f8b8466cfc127813a6d3091577c2304df20c3d8ebf554",
    build_file_content = "exports_files(['sbt'])",
  )

  ###### TOMCAT
  http_file(
    name = "tomcat_sample_war",
    downloaded_file_path = "tomcat-sample.war",
    urls = ["https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/sample.war"],
    sha256 = "89b33caa5bf4cfd235f060c396cb1a5acb2734a1366db325676f48c5f5ed92e5",
  )

  ###### YARN
  http_file(
    name = "yarnpkg",
    downloaded_file_path = "yarnpkg.deb",
    urls = ["https://github.com/yarnpkg/yarn/releases/download/v" + YARN_VERSION + "/yarn_" + YARN_VERSION + "_all.deb"],
    sha256 = "d1834b4d738cf4f8a5a5661ca5dda14d5b6c2ca3350e6424c68400bdfae73895",
  )

  ###### ZIPKIN
  http_file(
    name = "zipkin",
    downloaded_file_path = "zipkin.jar",
    urls = ["https://repo1.maven.org/maven2/io/zipkin/zipkin-server/" + ZIPKIN_VERSION + "/zipkin-server-" + ZIPKIN_VERSION + "-exec.jar"],
    sha256 = "1305fed981df2b5a460de7748d89dbca2afcf110fe74ed4e994015069beda27b",
  )

  ###### ZOOKEEPER
  http_archive(
    name = "zookeeper",
    url = "https://archive.apache.org/dist/zookeeper/zookeeper-" + ZOOKEEPER_VERSION + "/apache-zookeeper-" + ZOOKEEPER_VERSION + "-bin.tar.gz",
    sha256 = "fed19a8e8daa3cd49e721d61929b90613dc0b19faa8ccb7d0b3a85db46b0c922",
    build_file_content = "exports_files(['apache-zookeeper-" + ZOOKEEPER_VERSION + "-bin'])",
  )


  ###### JASPER
  http_archive(
    name = "jasper_server",
    url = "https://sourceforge.net/projects/jasperserver/files/JasperServer/JasperReports%20Server%20Community%20Edition%20" + JASPERREPORTS_SERVER_VERSION + "/TIB_js-jrs-cp_" + JASPERREPORTS_SERVER_VERSION + "_bin.zip/download",
    type = "zip",
    sha256 = "3f1a233f724b2c02b5e4d84e3cc9d8d619bc3a2acd9c9de7b2d869383510bedc",
    strip_prefix = "jasperreports-server-cp-" + JASPERREPORTS_SERVER_VERSION + "-bin",
    build_file_content = "exports_files([ \
      'jasperserver.war', \
      'apache-ant', \
      'buildomatic', \
    ])"
  )
  maven_jar(
    name = "postgresql_driver",
    artifact = "org.postgresql:postgresql:9.4.1212",
    sha1 = "38931d70811d9bfcecf9c06f7222973c038a12de",
  )

  http_archive(
    name = "pentaho_data_integration",
    url = "http://downloads.sourceforge.net/project/pentaho/Data%20Integration/7.1/pdi-ce-" + PENATHO_DI_VERSION + ".zip",
    sha256 = "e53a7e7327a50b19bb1d16a06d589a8ba3719e5a678abf5cea713503453d37f2",
    build_file_content = "exports_files(['data-integration'])",
  )
