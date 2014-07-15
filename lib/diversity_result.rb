module DiversityResult
  
  def dr_render
    respond_to do |format|
      format.html{
        yield
      }
      
      format.json {
        result = flash.to_hash.compact.map{|item| {status: item[0], content: item[1]}}.first
        flash.clear
        render json: result.to_json
      }
    end
  end
end