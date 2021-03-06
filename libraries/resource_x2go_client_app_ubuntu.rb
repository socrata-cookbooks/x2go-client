# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: x2go-client
# Library:: resource_x2go_client_app_ubuntu
#
# Copyright 2015-2016, Socrata, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative 'resource_x2go_client_app'

class Chef
  class Resource
    # A Ubuntu implementation of the x2go_client_app resource.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class X2goClientAppUbuntu < X2goClientApp
      provides :x2go_client_app, platform: 'ubuntu'

      #
      # Set up the X2go APT repo and install the client package.
      #
      action :install do
        new_resource.source.nil? && apt_repository('x2go') do
          uri 'ppa:x2go/stable'
          distribution node['lsb']['codename']
        end
        package(new_resource.source || 'x2goclient')
      end

      #
      # Uninstall the X2go client package and remove the APT repo.
      #
      action :remove do
        package('x2goclient') { action :remove }
        apt_repository('x2go') { action :remove }
      end
    end
  end
end
