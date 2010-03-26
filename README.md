BOSDK.gem
=========

Description
-----------

A JRuby wrapper for the Business Objects SDK

Requirements
------------

- The Business Objects Java SDK
- An environment variable 'BOE_JAVA_LIB' pointing to the Business Objects Java
  SDK directory
- JRuby >= 1.4.0

Usage
-----

    require 'bosdk'
    include BOSDK
    session = EnterpriseSession.new('cms', 'Administrator', '')
   
    stmt = "SELECT TOP 10 * FROM CI_SYSTEMOBJECTS WHERE SI_KIND='User'"
    session.query(stmt).each do |obj|
      puts obj.path
    end
  
    session.disconnect

Alternatively you can use the #connect closure.

    require 'bosdk'
    BOSDK.connect('cms', 'Administrator', '') do |session|
      stmt = "SELECT TOP 10 * FROM CI_SYSTEMOBJECTS WHERE SI_KIND='User'"
      session.query(stmt).each do |obj|
        puts obj.path
      end
    end

BOIRB
-----

The library ships with an extension to the standard irb shell that connects you
to a cms and gives you a handful of helpful shortcuts.
 
    connect(cms, username, password, options = Hash.new)
Creates a new EnterpriseSession and binds it to @boe.

    connected?
Tests whether @boe is connected to a cms.

    disconnect
Disconnects @boe from the cms.

    query(stmt)
Runs the provided query on @boe and returns the resulting InfoObject array.

    open_webi(docid)
Opens the specified InfoObject using a ReportEngine and returns a handle to the
WebiInstance. It also creates the following instance variables: @doc, @objs and
@vars. @doc is a handle to the WebiInstance, @objs is an alias for @doc.objects
and @vars is an alias for @doc.variables.

    objects
Shortcut to @objs which is an alias for @doc.objects

    variables
Shortcut to @vars which is an alias for @doc.variables

Resources
---------

- [Website](http://semmons99.github.com/bosdk)
- [Git Repo](http://github.com/semmons99/bosdk)
- [Twitter](http://twitter.com/bosdk_gem)
