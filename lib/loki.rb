require "singleton"
require "fileutils"

require "loki/time"
require "loki/logger"
require "loki/identity"
require "loki/file_pattern"
require "loki/file_path"
require "loki/task/base"
require "loki/task/proc"
require "loki/task/task"
require "loki/task/file"
require "loki/task/make"


module Loki

  def self.task(name = :task, &block)
    task = Task::Task.new(name)
    task.instance_eval(&block)
    # task.list
    task.work
  end


  private

  def self.block_unique_id(&block)
    source = block.source_location
    ::File.expand_path(source[0]) + ":#{source[1]}"
  end

end # module