# frozen_string_literal: true

#
# Cookbook Name:: x2go-client
# Library:: resource/x2go_client_app
#
# Copyright 2015-2018, Socrata, Inc.
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

require 'chef/resource'

class Chef
  class Resource
    # A Chef resource for the X2go client app.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class X2goClientApp < Resource
      provides :x2go_client_app do |_node|
        false
      end

      default_action :install

      #
      # Property to allow an override of the default package source path/URL.
      #
      property :source, kind_of: String, default: nil

      %i[install remove].each do |a|
        action a do
          raise(NotImplementedError,
                "Action '#{a}' must be implemented for '#{self.class}'")
        end
      end
    end
  end
end