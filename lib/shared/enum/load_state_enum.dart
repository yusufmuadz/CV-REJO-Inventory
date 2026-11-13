enum LoadStateEnum {
  initial, // Belum pernah mengambil data
  loading, // Pengambilan data pertama
  refreshing, // Refresh data (pull to refresh)
  loadingMore, // Pagination / infinite scroll
  success, // Berhasil mengambil data
  empty, // Berhasil tetapi data kosong
  error, // Gagal mengambil data
  noMore, // Tidak ada data berikutnya
}
