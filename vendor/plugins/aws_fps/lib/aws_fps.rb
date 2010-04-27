# Amazon FPS Plugin
require 'net/https'
require 'time'
require 'openssl'
require 'base64'
require 'yaml'
require 'aws_fps/signature'
require 'aws_fps/pipeline'
require 'aws_fps/query'
require 'aws_fps/tokens'
require 'aws_fps/payment'

module AWS_FPS
  # Load AWS config
  path = File.expand_path "#{RAILS_ROOT}/config/amazon_fps.yml"
  file = YAML.load_file path
  config = file[RAILS_ENV].symbolize_keys

  # Set default params and AWS keys
  $KCODE            = "u"
  PIPELINE          = config[:pipeline]
  ENDPOINT          = config[:endpoint]
  VERSION           = config[:version]
  ACCESS_KEY        = config[:access_key]
  SECRET_ACCESS_KEY = config[:secret_access_key]
  SIGNATURE_VERSION = "1"
end