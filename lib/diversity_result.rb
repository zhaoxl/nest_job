module DiversityResult
  
  def dr_render
    respond_to do |format|
      format.html{
        yield
      }
      
      format.json {
        result = flash.to_hash.compact.first || [:success, ""]
        result = {status: result[0], content: result[1]}
        flash.clear
        render json: result.to_json
      }
    end
  end
end