#!/bin/bash -e

# Adapted from the guidance provided at http://nifi.apache.org/development/release-guide.html
repository=orgapachenifi-1079
version=0.6.0
base_url=https://repository.apache.org/service/local/repositories/${repository}/content/org/apache/nifi/nifi/${version}

release_file=nifi-${version}-source-release.zip
release_git_commit_hash=0b9bd20d31d7f805300254da768d91b973480151

print_section_header() {
    echo
    echo ----------------------------------------------
    echo
    echo "$@"
    echo
    echo ----------------------------------------------
    echo
}

echo Base URL=${base_url}

print_section_header "Acquiring release source for version ${version}"
wget ${base_url}/${release_file}
unzip ${release_file}

print_section_header "Find possible binary files"
# Assumes GNU compatible find.  OS X uses BSD by default but can achieve similar with `brew install findutils` and prefixing the
# associated path (/usr/local/opt/findutils/libexec/gnubin) to $PATH
# taken from http://unix.stackexchange.com/questions/1484/how-to-find-binary-executables-within-a-directory
find -type f -executable -exec sh -c "file -i '{}' | grep -q 'x-executable; charset=binary'" \; -print

print_section_header "Determine and validate hashes"
echo md5sum: $(md5sum ${release_file} | cut -d' ' -f1);
echo Remote md5sum: $(curl -s ${base_url}/${release_file}.md5)

echo sha1sum: $(sha1sum ${release_file} | cut -d' ' -f1);
echo Remote sha1sum: $(curl -s ${base_url}/${release_file}.sha1)

echo sha256sum: $(shasum -a256 ${release_file} | cut -d' ' -f1);
echo Remote sha256sum: $(curl -s ${base_url}/${release_file}.sha256)


print_section_header "validate signatures"
wget ${base_url}/${release_file}.asc

# Assumes you have the signer's public key imported
gpg --verify ${release_file}.asc ${release_file}

print_section_header "Acquiring source repository"
git clone https://git-wip-us.apache.org/repos/asf/nifi.git


print_section_header "Performing diff of release versus source commit"
diff --brief -r nifi-${version} nifi

print_section_header "Performing build with contrib-check"
mvn -f nifi-${version}/pom.xml clean install -Pcontrib-check

print_section_header "Starting nifi"
./nifi-${version}/nifi-assembly/target/nifi-${version}-bin/nifi-${version}/bin/nifi.sh start
echo listening for application to start
attempt=1
started="no"
while [ $attempt -le 6 ]
    do
      curl -f http://localhost:8080/nifi-api/controller/ && started="yes" && break
      echo NiFi was not available for attempt ${attempt}, sleeping
      attempt=$[$attempt+1]
      sleep 10
   done

print_section_header "Stopping nifi"
./nifi-${version}/nifi-assembly/target/nifi-${version}-bin/nifi-${version}/bin/nifi.sh stop

print_section_header "NiFi was $([[ $started == "yes" ]] && echo "" || echo "not") successfully started"