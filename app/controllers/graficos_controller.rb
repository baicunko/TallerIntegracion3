class GraficosController < ApplicationController
  def index
    @r1_array=[]
    @r2_array=[]
    @r3_array=[]

	@q_grafico=Quiebre.group("date(fechaquiebre)").count
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
    @b_q_array=[]
    @b_v_array=[]

    suma=0
    @bar_q_graf=Quiebre.all.order("fechaquiebre").group_by{|u| u.fechaquiebre.beginning_of_week}
    @bar_q_graf.each do |q|
      q[1].each do |r|
        suma+=r.dineroperdido
      end
      @b_q_array << [q[0].to_i*1000,suma]
    end
    @bar_v_graf=SentItemsPedido.all.order("created_at").group_by{|u| u.created_at.beginning_of_week}
    @bar_v_graf.each do |v|
      v[1].each do |r|
        suma+=(r.cantidad*r.precio)
      end
      @b_v_array << [v[0].to_datetime.to_i*1000,suma]
    end





  end
end
