swift-manager (beta)
===== 

swift-manager aims to be a Ruby based OpenStack Swift Client with a git-like interface used to test and manage native Swift and AWS S3 APIs. This version builds on the excellent Ruby Fog gem. Furture versions may use native JSON/XML.

##Audience

swift-manager is targeted towards Developers building applications on Swift or S3 APIs. However, anyone wanting to use it to test a Swift Cloud or S3 semantics may find it useful.

##Features


Supported on Ruby 1.9.3-p125 and JRuby-1.6.7

1. Ability to create/delete containers and objects in S3 and native APIs. No CDN is supported at this time.
2. Ability to list containers and objects (files)
3. Batch jobs:
	a. create containers at scale by providing a container prefix and the number of containers to create
	b. upload files to a container (can be used for backups)
4. Unix-like(read-only) shell to browse containers with TAB completion (very basic)

##Install

gem install swift-manager

##Documentation

1. swift-manager help command
2. Read examples.pdf in the docs directory
3. Todos.txt in the docs directory (patches are more than welcome!)

####ToDos

1. CDN support and CDN enable existing containers
2. Shell support for listing files
3. 


