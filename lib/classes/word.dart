class Word {
  final String foreignVersion;
  final String transVersion;
  final Set<String> tags;
  final String description;

  Word({required this.foreignVersion, required this.transVersion, required this.tags, required this.description});
}