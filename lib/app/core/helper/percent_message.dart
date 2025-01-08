String getPriceMessage(double changePercent) {
  if (changePercent > 0) {
    if (changePercent <= 1) {
      return "Leve alta! O mercado está mostrando sinais positivos.";
    } else if (changePercent <= 5) {
      return "Parece que algo bom está por vir!";
    } else {
      return "Comprar para não se arrepender!!";
    }
  } else if (changePercent < 0) {
    if (changePercent >= -1) {
      return "Leve queda. Nada fora do comum no mercado.";
    } else if (changePercent >= -5) {
      return "Espera cair mais um pouco para comprar!";
    } else {
      return "Hora de comprar!";
    }
  } else {
    return "Sem alterações no momento.";
  }
}
