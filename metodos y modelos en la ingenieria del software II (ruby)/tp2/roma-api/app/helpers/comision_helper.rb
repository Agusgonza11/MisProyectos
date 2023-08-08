module WebTemplate
  class App
    module ComisionHelper
      def comision_to_json(comision, repartidor_id)
        {comision: comision, id: repartidor_id}.to_json
      end
    end

    helpers ComisionHelper
  end
end
