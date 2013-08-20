require 'elastics-client'
require 'elastics/scope/utils'
require 'elastics/scope/filter_methods'
require 'elastics/scope/vars_methods'
require 'elastics/scope/query_methods'
require 'elastics/scope'
require 'elastics/scopes'
require 'elastics/result/scope'

Elastics::LIB_PATHS << File.dirname(__FILE__)

Elastics::Conf.result_extenders |= [Elastics::Result::Scope]

Elastics.send(:include, Elastics::Scopes)
