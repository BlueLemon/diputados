class Backend::NotasController < Backend::AuthenticatedApplicationController
  respond_to :pdf, :html
  def index

    respond_to do |format|
      format.html { super }
      format.pdf do
        Nota.per_page = 200
        report = NotasReport.new(collection)
        report = report.listado_notas
        send_file report, :type => "application/vnd.oasis.opendocument.text"
      end
    end
  end

  def new
    @nota = Nota.new
    @nota.build_pases
    @nota.build_initiator
  end

  def show
    @nota = Nota.find(params[:id])

    @tags = @nota.tags.map do |t|
      t.name
    end
  end

  def edit
    @nota = Nota.find params[:id]
    @nota.build_initiator unless @nota.initiator
  end

  def attributes
    [:id, :year, :ingreso, :area]
  end

end
