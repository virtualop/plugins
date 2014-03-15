description "moves old database logging partitions into the archive (drops the original tables)"

execute do |params|
  partitions = @op.find_old_partitions
  @op.move_partition_into_archive('partition_name' => partitions)
end
