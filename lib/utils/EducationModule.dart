class EducationModule {
  final String title; // Judul dari modul pendidikan.
  final String description; // Deskripsi atau konten dari modul pendidikan.
  final String videoUrl; // URL video yang terkait dengan modul ini.
  final String thumbnail; // URL thumbnail untuk video modul ini.

  // Konstruktor untuk inisialisasi objek EducationModule.
  EducationModule({
    required this.title, // Parameter wajib untuk judul.
    required this.description, // Parameter wajib untuk deskripsi.
    required this.videoUrl, // Parameter wajib untuk URL video.
    required this.thumbnail, // Parameter wajib untuk URL thumbnail.
  });
}
