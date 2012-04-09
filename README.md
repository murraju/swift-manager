swift-manager (beta)
===== 

swift-manager aims to be a Ruby based OpenStack Swift Client with a git-like interface used to test and manage native Swift and AWS S3 APIs. This version builds on the excellent Ruby Fog gem. Furture versions may use native JSON/XML. Currently uses JSON for configuration files located under ~/.swift-manager.

##Audience

swift-manager is targeted towards Developers to test Swift or S3 APIs. However, anyone wanting to use it to test a Swift Cloud or S3 semantics may find it useful.

##Features


Supported on Ruby 1.9.3-p125 and JRuby-1.6.7

1. Ability to create/delete containers and objects in S3 and Swift native APIs. No CDN is supported at this time.
2. Ability to list containers and objects (files)
3. Batch jobs:
	a. create containers at scale by providing a container prefix and the number of containers to create
	b. upload files to a container (can be used for backups)
4. Unix-like(read-only) shell to browse containers with TAB completion (very basic)

**Assumptions: The current implementation requires SSL at the Swift Proxy server due to Ruby Fog dependencies. Make sure to have the following in /etc/swift/proxy-server.conf

[DEFAULT]
cert_file = /etc/swift/cert.crt
key_file = /etc/swift/cert.key


##Install

After installing a Ruby or JRuby, run:

gem install swift-manager

##Documentation

1. swift-manager help command
2. Read swift-manager.pdf in the docs directory

####ToDos (Patches are Welcome!)

1. CDN support and CDN enable existing containers
2. Shell support for listing objects
3. Write support for Shell. Example, implement"create or touch commands" to create containers and objects
4. More granulor metrics for create and delete containers/objects in order to test large requests (millions)
5. Implement port, URL, and other parameters for Authentiation Configuration JSON






