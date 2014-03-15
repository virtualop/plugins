param! 'filter', 'regular expression used to filter partition names', :default_param => true

execute do |params|
  @op.list_archived_partitions.select { |x|
    /#{params['filter']}/ =~ x
  }.each do |partition|
    @op.restore_partition_from_archive partition
  end
end
