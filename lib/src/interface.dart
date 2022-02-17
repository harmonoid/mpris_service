import 'package:dbus/dbus.dart';
import 'package:mpris_service/src/mpris_service.dart';

class Interface extends DBusObject {
  final MPRISServiceState state;

  /// Creates a new object to expose on [path].
  Interface(this.state, DBusObjectPath path) : super(path);

  /// Gets value of property org.mpris.MediaPlayer2.CanQuit
  Future<DBusMethodResponse> getCanQuit() async {
    return DBusMethodSuccessResponse([DBusBoolean(state.canQuit)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Fullscreen
  Future<DBusMethodResponse> getFullscreen() async {
    return DBusMethodSuccessResponse([DBusBoolean(state.fullscreen)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Fullscreen
  Future<DBusMethodResponse> setFullscreen(bool value) async {
    state.setFullscreen?.call(value);
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.CanSetFullscreen
  Future<DBusMethodResponse> getCanSetFullscreen() async {
    return DBusMethodSuccessResponse([DBusBoolean(state.canSetFullscreen)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.CanRaise
  Future<DBusMethodResponse> getCanRaise() async {
    return DBusMethodSuccessResponse([DBusBoolean(state.canRaise)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.HasTrackList
  Future<DBusMethodResponse> getHasTrackList() async {
    return DBusMethodSuccessResponse([DBusBoolean(state.hasTrackList)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Identity
  Future<DBusMethodResponse> getIdentity() async {
    return DBusMethodSuccessResponse([DBusString(state.identity)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.DesktopEntry
  Future<DBusMethodResponse> getDesktopEntry() async {
    return DBusMethodSuccessResponse([DBusString(state.desktopEntry)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.SupportedUriSchemes
  Future<DBusMethodResponse> getSupportedUriSchemes() async {
    return DBusMethodSuccessResponse(
      [
        DBusArray(
          DBusSignature('s'),
          state.supportedUriSchemes.map((e) => DBusString(e)),
        )
      ],
    );
  }

  /// Gets value of property org.mpris.MediaPlayer2.SupportedMimeTypes
  Future<DBusMethodResponse> getSupportedMimeTypes() async {
    return DBusMethodSuccessResponse(
      [
        DBusArray(
          DBusSignature('s'),
          state.supportedMimeTypes.map((e) => DBusString(e)),
        )
      ],
    );
  }

  /// Implementation of org.mpris.MediaPlayer2.Raise()
  Future<DBusMethodResponse> doRaise() async {
    state.doRaise?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Quit()
  Future<DBusMethodResponse> doQuit() async {
    state.doQuit?.call();
    return DBusMethodSuccessResponse();
  }

  Future<DBusMethodResponse> getPlaybackStatus() async {
    return DBusMethodSuccessResponse([
      DBusString(
        state.isCompleted
            ? 'Stopped'
            : state.isPlaying
                ? 'Playing'
                : 'Paused',
      ),
    ]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.LoopStatus
  Future<DBusMethodResponse> getLoopStatus() async {
    return DBusMethodSuccessResponse([DBusString(state.loopStatus)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.LoopStatus
  Future<DBusMethodResponse> setLoopStatus(String value) async {
    state.setLoopStatus?.call(value);
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> getRate() async {
    return DBusMethodSuccessResponse([DBusDouble(state.rate)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> setRate(double value) async {
    state.setRate?.call(value);
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Shuffle
  Future<DBusMethodResponse> getShuffle() async {
    return DBusMethodSuccessResponse([DBusBoolean(state.isShuffling)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Shuffle
  Future<DBusMethodResponse> setShuffle(bool value) async {
    state.setShuffle?.call(value);
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Metadata
  Future<DBusMethodResponse> getMetadata() async {
    /// https://www.freedesktop.org/wiki/Specifications/mpris-spec/metadata
    if (state.playlist.isEmpty) {
      return DBusMethodSuccessResponse(
        [DBusDict(DBusSignature('s'), DBusSignature('v'), {})],
      );
    }
    final i = state.index.clamp(0, state.playlist.length - 1);
    final track = state.playlist[i];
    return DBusMethodSuccessResponse([
      DBusDict(
        DBusSignature('s'),
        DBusSignature('v'),
        {
          DBusString('mpris:trackid'): DBusVariant(
            DBusObjectPath(
              '/' + track.uri.toString().hashCode.toString(),
            ),
          ),
          DBusString('mpris:length'): DBusVariant(
            DBusInt64(track.duration?.inMicroseconds ?? 0),
          ),
          DBusString('mpris:artUrl'): DBusVariant(
            DBusString(track.artworkUri),
          ),
          DBusString('xesam:album'): DBusVariant(
            DBusString(track.albumName),
          ),
          DBusString('xesam:albumArtist'): DBusVariant(
            DBusArray(DBusSignature('s'), [
              DBusString(track.albumArtistName),
            ]),
          ),
          DBusString('xesam:artist'): DBusVariant(
            DBusArray(
              DBusSignature('s'),
              track.trackArtistNames.map((e) => DBusString(e)),
            ),
          ),
          if (track.year != 'Unknown Year')
            DBusString('xesam:contentCreated'): DBusVariant(
              DBusString('${track.year}-01-01T00:00:00.000'),
            ),
          DBusString('xesam:discNumber'): DBusVariant(
            DBusInt32(1),
          ),
          DBusString('xesam:firstUsed'): DBusVariant(
            DBusString(track.timeAdded.toIso8601String()),
          ),
          DBusString('xesam:title'): DBusVariant(
            DBusString(track.trackName),
          ),
          DBusString('xesam:trackNumber'): DBusVariant(
            DBusInt32(track.trackNumber),
          ),
          DBusString('xesam:url'): DBusVariant(
            DBusString(track.uri.toString()),
          ),
        },
      ),
    ]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> getVolume() async {
    return DBusMethodSuccessResponse([DBusDouble(state.volume / 100)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> setVolume(double value) async {
    state.setVolume?.call(value * 100);
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Position
  Future<DBusMethodResponse> getPosition() async {
    return DBusMethodSuccessResponse(
      [DBusInt64(state.position.inMicroseconds)],
    );
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MinimumRate
  Future<DBusMethodResponse> getMinimumRate() async {
    return DBusMethodSuccessResponse([DBusDouble(0.5)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MaximumRate
  Future<DBusMethodResponse> getMaximumRate() async {
    return DBusMethodSuccessResponse([DBusDouble(2.0)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanGoNext
  Future<DBusMethodResponse> getCanGoNext() async {
    return DBusMethodSuccessResponse(
      [DBusBoolean(state.index < state.playlist.length - 1)],
    );
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanGoPrevious
  Future<DBusMethodResponse> getCanGoPrevious() async {
    return DBusMethodSuccessResponse(
      [DBusBoolean(state.index > 0)],
    );
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanPlay
  Future<DBusMethodResponse> getCanPlay() async {
    return DBusMethodSuccessResponse(
      [DBusBoolean(true)],
    );
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanPause
  Future<DBusMethodResponse> getCanPause() async {
    return DBusMethodSuccessResponse(
      [DBusBoolean(true)],
    );
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanSeek
  Future<DBusMethodResponse> getCanSeek() async {
    return DBusMethodSuccessResponse(
      [DBusBoolean(true)],
    );
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanControl
  Future<DBusMethodResponse> getCanControl() async {
    return DBusMethodSuccessResponse(
      [DBusBoolean(true)],
    );
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Next()
  Future<DBusMethodResponse> doNext() async {
    state.doNext?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Previous()
  Future<DBusMethodResponse> doPrevious() async {
    state.doPrevious?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Pause()
  Future<DBusMethodResponse> doPause() async {
    state.doPause?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.PlayPause()
  Future<DBusMethodResponse> doPlayPause() async {
    state.doPlayPause?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Stop()
  Future<DBusMethodResponse> doStop() async {
    state.doStop?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Play()
  Future<DBusMethodResponse> doPlay() async {
    state.doPlay?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Seek()
  Future<DBusMethodResponse> doSeek(int value) async {
    state.doSeek?.call(value);
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.SetPosition()
  Future<DBusMethodResponse> doSetPosition(
      String trackObjectPath, int position) async {
    state.doSetPosition?.call(trackObjectPath, position);
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.OpenUri()
  Future<DBusMethodResponse> doOpenUri(String uri) async {
    state.doOpenUri?.call(Uri.parse(uri));
    return DBusMethodSuccessResponse();
  }

  /// Emits signal org.mpris.MediaPlayer2.Player.Seeked
  Future<void> emitSeeked(int position) async {
    await emitSignal(
        'org.mpris.MediaPlayer2.Player', 'Seeked', [DBusInt64(position)]);
  }

  @override
  List<DBusIntrospectInterface> introspect() {
    return [
      DBusIntrospectInterface('org.mpris.MediaPlayer2', methods: [
        DBusIntrospectMethod('Raise'),
        DBusIntrospectMethod('Quit')
      ], properties: [
        DBusIntrospectProperty('CanQuit', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Fullscreen', DBusSignature('b'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('CanSetFullscreen', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanRaise', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('HasTrackList', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Identity', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('DesktopEntry', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('SupportedUriSchemes', DBusSignature('as'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('SupportedMimeTypes', DBusSignature('as'),
            access: DBusPropertyAccess.read)
      ]),
      DBusIntrospectInterface('org.mpris.MediaPlayer2.Player', methods: [
        DBusIntrospectMethod('Next'),
        DBusIntrospectMethod('Previous'),
        DBusIntrospectMethod('Pause'),
        DBusIntrospectMethod('PlayPause'),
        DBusIntrospectMethod('Stop'),
        DBusIntrospectMethod('Play'),
        DBusIntrospectMethod('Seek', args: [
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_,
              name: 'Offset')
        ]),
        DBusIntrospectMethod('SetPosition', args: [
          DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.in_,
              name: 'TrackId'),
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_,
              name: 'Position')
        ]),
        DBusIntrospectMethod('OpenUri', args: [
          DBusIntrospectArgument(DBusSignature('s'), DBusArgumentDirection.in_,
              name: 'Uri')
        ])
      ], signals: [
        DBusIntrospectSignal('Seeked', args: [
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.out,
              name: 'Position')
        ])
      ], properties: [
        DBusIntrospectProperty('PlaybackStatus', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('LoopStatus', DBusSignature('s'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Rate', DBusSignature('d'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Shuffle', DBusSignature('b'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Metadata', DBusSignature('a{sv}'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Volume', DBusSignature('d'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Position', DBusSignature('x'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('MinimumRate', DBusSignature('d'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('MaximumRate', DBusSignature('d'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanGoNext', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanGoPrevious', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanPlay', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanPause', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanSeek', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanControl', DBusSignature('b'),
            access: DBusPropertyAccess.read)
      ])
    ];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.interface == 'org.mpris.MediaPlayer2') {
      if (methodCall.name == 'Raise') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doRaise();
      } else if (methodCall.name == 'Quit') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doQuit();
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else if (methodCall.interface == 'org.mpris.MediaPlayer2.Player') {
      if (methodCall.name == 'Next') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doNext();
      } else if (methodCall.name == 'Previous') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPrevious();
      } else if (methodCall.name == 'Pause') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPause();
      } else if (methodCall.name == 'PlayPause') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPlayPause();
      } else if (methodCall.name == 'Stop') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doStop();
      } else if (methodCall.name == 'Play') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPlay();
      } else if (methodCall.name == 'Seek') {
        if (methodCall.signature != DBusSignature('x')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doSeek((methodCall.values[0] as DBusInt64).value);
      } else if (methodCall.name == 'SetPosition') {
        if (methodCall.signature != DBusSignature('ox')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doSetPosition((methodCall.values[0] as DBusObjectPath).value,
            (methodCall.values[1] as DBusInt64).value);
      } else if (methodCall.name == 'OpenUri') {
        if (methodCall.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doOpenUri((methodCall.values[0] as DBusString).value);
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else {
      return DBusMethodErrorResponse.unknownInterface();
    }
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    if (interface == 'org.mpris.MediaPlayer2') {
      if (name == 'CanQuit') {
        return getCanQuit();
      } else if (name == 'Fullscreen') {
        return getFullscreen();
      } else if (name == 'CanSetFullscreen') {
        return getCanSetFullscreen();
      } else if (name == 'CanRaise') {
        return getCanRaise();
      } else if (name == 'HasTrackList') {
        return getHasTrackList();
      } else if (name == 'Identity') {
        return getIdentity();
      } else if (name == 'DesktopEntry') {
        return getDesktopEntry();
      } else if (name == 'SupportedUriSchemes') {
        return getSupportedUriSchemes();
      } else if (name == 'SupportedMimeTypes') {
        return getSupportedMimeTypes();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return getPlaybackStatus();
      } else if (name == 'LoopStatus') {
        return getLoopStatus();
      } else if (name == 'Rate') {
        return getRate();
      } else if (name == 'Shuffle') {
        return getShuffle();
      } else if (name == 'Metadata') {
        return getMetadata();
      } else if (name == 'Volume') {
        return getVolume();
      } else if (name == 'Position') {
        return getPosition();
      } else if (name == 'MinimumRate') {
        return getMinimumRate();
      } else if (name == 'MaximumRate') {
        return getMaximumRate();
      } else if (name == 'CanGoNext') {
        return getCanGoNext();
      } else if (name == 'CanGoPrevious') {
        return getCanGoPrevious();
      } else if (name == 'CanPlay') {
        return getCanPlay();
      } else if (name == 'CanPause') {
        return getCanPause();
      } else if (name == 'CanSeek') {
        return getCanSeek();
      } else if (name == 'CanControl') {
        return getCanControl();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> setProperty(
      String interface, String name, DBusValue value) async {
    if (interface == 'org.mpris.MediaPlayer2') {
      if (name == 'CanQuit') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Fullscreen') {
        if (value.signature != DBusSignature('b')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setFullscreen((value as DBusBoolean).value);
      } else if (name == 'CanSetFullscreen') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanRaise') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'HasTrackList') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Identity') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'DesktopEntry') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'SupportedUriSchemes') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'SupportedMimeTypes') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'LoopStatus') {
        if (value.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setLoopStatus((value as DBusString).value);
      } else if (name == 'Rate') {
        if (value.signature != DBusSignature('d')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setRate((value as DBusDouble).value);
      } else if (name == 'Shuffle') {
        if (value.signature != DBusSignature('b')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setShuffle((value as DBusBoolean).value);
      } else if (name == 'Metadata') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Volume') {
        if (value.signature != DBusSignature('d')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setVolume((value as DBusDouble).value);
      } else if (name == 'Position') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'MinimumRate') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'MaximumRate') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanGoNext') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanGoPrevious') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanPlay') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanPause') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanSeek') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanControl') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> getAllProperties(String interface) async {
    var properties = <String, DBusValue>{};
    if (interface == 'org.mpris.MediaPlayer2') {
      properties['CanQuit'] = (await getCanQuit()).returnValues[0];
      properties['Fullscreen'] = (await getFullscreen()).returnValues[0];
      properties['CanSetFullscreen'] =
          (await getCanSetFullscreen()).returnValues[0];
      properties['CanRaise'] = (await getCanRaise()).returnValues[0];
      properties['HasTrackList'] = (await getHasTrackList()).returnValues[0];
      properties['Identity'] = (await getIdentity()).returnValues[0];
      properties['DesktopEntry'] = (await getDesktopEntry()).returnValues[0];
      properties['SupportedUriSchemes'] =
          (await getSupportedUriSchemes()).returnValues[0];
      properties['SupportedMimeTypes'] =
          (await getSupportedMimeTypes()).returnValues[0];
    }
    if (interface == 'org.mpris.MediaPlayer2.Player') {
      properties['PlaybackStatus'] =
          (await getPlaybackStatus()).returnValues[0];
      properties['LoopStatus'] = (await getLoopStatus()).returnValues[0];
      properties['Rate'] = (await getRate()).returnValues[0];
      properties['Shuffle'] = (await getShuffle()).returnValues[0];
      properties['Metadata'] = (await getMetadata()).returnValues[0];
      properties['Volume'] = (await getVolume()).returnValues[0];
      properties['Position'] = (await getPosition()).returnValues[0];
      properties['MinimumRate'] = (await getMinimumRate()).returnValues[0];
      properties['MaximumRate'] = (await getMaximumRate()).returnValues[0];
      properties['CanGoNext'] = (await getCanGoNext()).returnValues[0];
      properties['CanGoPrevious'] = (await getCanGoPrevious()).returnValues[0];
      properties['CanPlay'] = (await getCanPlay()).returnValues[0];
      properties['CanPause'] = (await getCanPause()).returnValues[0];
      properties['CanSeek'] = (await getCanSeek()).returnValues[0];
      properties['CanControl'] = (await getCanControl()).returnValues[0];
    }
    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }
}
