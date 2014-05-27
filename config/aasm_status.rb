module AASM
	module ClassMethods
		define_method :aasm_status do |aasm_states_group, event_transitions_group, options={column: :status}|
			aasm options do
				aasm_states_group.each do |aasm_st|
					aast = aasm_st.map{|st| st.inspect} * ", "
					instance_eval("send :state, #{aast}")
				end
				event_transitions_group.each do |event_tran|
					ev_tran = event_tran.first.map{|tran| tran.inspect} * ", "
					instance_eval("send :event, #{ev_tran} do 
								transitions from: #{event_tran[1]}, to: :#{event_tran[2]}
							end")
				end
			end
		end
	end
end