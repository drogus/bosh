require "erb"
require "tempfile"

module Bosh; end
require "common/properties"

class Deployment

  def initialize(spec)
    @spec = spec
    generate_deployment_manifest(spec)
  end

  def name
    @yaml["name"]
  end

  def to_path
    @path
  end

  def delete
    puts "<-- rm #@path" if debug?
    FileUtils.rm_rf(File.dirname(to_path)) unless keep?
  end

  def generate_deployment_manifest(spec)
    @context = Bosh::Common::TemplateEvaluationContext.new(spec)
    result = ERB.new(load_template(@context.spec.cpi)).result(@context.get_binding)

    if debug?
      puts "# Deployment manifest generated from: #{template_file(@context.spec.cpi)}"
      puts result
      puts '#/Deployment manifest'
    end

    @yaml = Psych::load(result)
    store_manifest(result)
  end

  def store_manifest(content)
    manifest = tempfile("deployment")
    manifest.write(content)
    manifest.close
    @path = manifest.path
  end

  def load_template(cpi)
    File.read(template_file(cpi))
  end

  def tempfile(name)
    File.open(File.join(Dir.mktmpdir, name), "w")
  end

  private

  def template_file(cpi)
    File.expand_path("../../templates/#{cpi}.yml.erb", __FILE__)
  end

  def debug?
    ENV['BAT_DEBUG'] == "verbose"
  end

  def keep?
    ENV['BAT_MANIFEST'] == "keep"
  end
end
