class InvoicesController < ApplicationController

  def index
    @invoices = Invoice.all
  end

  def show 
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
      	pdf = InvoicePdf.new(@invoice, view_context)
      	send_data pdf.render, filename:
      	"invoice_#{@invoice.created_at.strftime("%d/%m/%Y")}.pdf", type: "application/pdf"
      end
    end
  end

  def new
  end
  
  def create
    @invoice = Invoice.new(invoice_params)
    
    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@invoice = Invoice.find(params[:id])

    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
