# frozen_string_literal: true

module Performa
  module Coordinator
    module_function

    extend ShellHelper

    def run(config)
      envs = Environment.all(config)
      results = {}

      envs.each do |env|
        results[env.name] = process_env(env, config: config)
      end

      ResultsHelper.process(results, config: config)
    ensure
      ContainerRegistry.kill_all
    end

    def process_env(env, config:)
      LOG.info_notice("Processing #{[env.image, env&.stage&.first].compact}")
      container_id = Images.process(env, config: config)
      unless container_id.from_cache
        Stages.process(env, container_id: container_id)
        Images.cache_container(container_id, tag: env.hash) if config.cachable_envs?
      end

      result = run_command("docker container exec #{container_id} #{config['command']}", success_only: false)
      ContainerRegistry.kill(container_id)
      result
    end
  end
end