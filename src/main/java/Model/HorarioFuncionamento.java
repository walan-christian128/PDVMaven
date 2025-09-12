package Model;

public class HorarioFuncionamento {
    private int diaSemana; // 0=Dom, 1=Seg, ..., 6=Sáb
    private String horaAbertura; // Formato "HH:MM"
    private String horaFechamento; // Formato "HH:MM"
    private boolean aberto;
    private String observacao; // Opcional

    // ✅ Construtor vazio (necessário para setar valores manualmente depois)
    public HorarioFuncionamento() {
    }

    // Construtor completo
    public HorarioFuncionamento(int diaSemana, String horaAbertura, String horaFechamento, boolean aberto, String observacao) {
        this.diaSemana = diaSemana;
        this.horaAbertura = horaAbertura;
        this.horaFechamento = horaFechamento;
        this.aberto = aberto;
        this.observacao = observacao;
    }

    // Getters e Setters
    public int getDiaSemana() {
        return diaSemana;
    }

    public void setDiaSemana(int diaSemana) {
        this.diaSemana = diaSemana;
    }

    public String getHoraAbertura() {
        return horaAbertura;
    }

    public void setHoraAbertura(String horaAbertura) {
        this.horaAbertura = horaAbertura;
    }

    public String getHoraFechamento() {
        return horaFechamento;
    }

    public void setHoraFechamento(String horaFechamento) {
        this.horaFechamento = horaFechamento;
    }

    public boolean isAberto() {
        return aberto;
    }

    public void setAberto(boolean aberto) {
        this.aberto = aberto;
    }

    public String getObservacao() {
        return observacao;
    }

    public void setObservacao(String observacao) {
        this.observacao = observacao;
    }
}
