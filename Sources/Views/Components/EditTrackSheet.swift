import SwiftUI

/// Personnaliser le titre, l'artiste et l'album d'une musique (le fichier audio n'est pas modifié).
struct EditTrackSheet: View {
    @EnvironmentObject private var library: LibraryStore
    @Environment(\.dismiss) private var dismiss

    let track: Track

    @State private var title: String
    @State private var artist: String
    @State private var album: String

    init(track: Track) {
        self.track = track
        _title = State(initialValue: track.title)
        _artist = State(initialValue: track.artist)
        _album = State(initialValue: track.album == Track.unknownAlbum ? "" : track.album)
    }

    private var canSave: Bool {
        !LibraryStore.cleanName(title).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Titre") {
                    TextField("Titre", text: $title)
                }
                .listRowBackground(Theme.card)

                Section {
                    TextField("Artiste", text: $artist)
                } header: {
                    Text("Artiste")
                } footer: {
                    Text("Laissez vide pour « \(Track.unknownArtist) ».")
                }
                .listRowBackground(Theme.card)

                Section {
                    TextField("Album", text: $album)
                } header: {
                    Text("Album")
                } footer: {
                    Text("Les titres qui ont le même album et le même artiste sont regroupés. Seules les informations affichées dans Freetify changent, pas le fichier.")
                }
                .listRowBackground(Theme.card)
            }
            .scrollContentBackground(.hidden)
            .appBackground()
            .navigationTitle("Modifier la musique")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        library.updateTrack(track.id, title: title, artist: artist, album: album)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
