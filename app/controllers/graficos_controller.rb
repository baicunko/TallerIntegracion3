class GraficosController < ApplicationController
  def index
    @r1_array=[]
    @r2_array=[]
    @r3_array=[]

	@q_grafico=Quiebre.group("date(created_at)").count
    @q_grafico.each do |q|
       @r1_array << [q[0].to_datetime.to_i*1000, q[1]]
       	if q[0].to_date>=Date.today-1.month
   			@r2_array << [q[0].to_date.to_datetime.to_i*1000, q[1]]
       		if q[0].to_date>=Date.today-7.day
       			@r3_array << [q[0].to_datetime.to_i*1000, q[1]]
       		end
       	end
    end
    @v1_array=[]
    @v2_array=[]
    @v3_array=[]

    @v_grafico=SentItemsPedido.group("date(created_at)").count
    @v_grafico.each do |v|
       @v1_array << [v[0].to_datetime.to_i*1000, v[1]]
    	if v[0].to_date>=Date.today-1.month
       		@v2_array << [v[0].to_date.to_datetime.to_i*1000, v[1]]
       		if v[0].to_date>=Date.today-7.day
       			@v3_array << [v[0].to_datetime.to_i*1000, v[1]]
       		end
       	end

     end




  end
end
