String wrapNullableIfNecessary(
    String expression, String output, bool nullable) {
  if (!nullable) {
    return output;
  }
  return expression + ' != null ? ' + output + ' : null';
}
