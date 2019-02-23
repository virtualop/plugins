description "removes all machines that have not been seen for more than 7 days"

param "just_kidding", default: false

run do |just_kidding|
  morituri = @op.old_machines || []
  morituri.each do |machine|
    one_machine = Machine.where(name: machine.name).first
    unless one_machine.nil?
      if just_kidding
        $logger.warn "not really deleting #{one_machine.name}"
      else
        one_machine.delete
      end
    end
  end
end
