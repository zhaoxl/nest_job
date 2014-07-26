module DiversityResult
  
  def dr_render
    respond_to do |format|
      format.html{
        yield
      }
      
      format.json {
        msgs = flash.to_hash.compact
        flash.clear
        result = msgs.extract!(:success, :error).first || [:success, ""]
        result = {status: result[0].to_s, content: result[1]}
        result.merge! msgs
        
        render json: result.to_json
      }
    end
  end
end