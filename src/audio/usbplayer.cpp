#include "usbplayer.h"
#include <QDir>
#include <QUrl>

UsbPlayer::UsbPlayer(QObject *parent)
    : AudioSourceBase(parent)
    , m_player(new QMediaPlayer(this))
    , m_usbPath("/media/ayman/830fc2d1-809b-4a46-b9cf-2d08cf1852b2")
    , m_index(0)
    , m_isVideo(false)
{
    connect(m_player, &QMediaPlayer::positionChanged,
            this, [this](qint64 pos){ setPositionInternal(pos); });

    connect(m_player, &QMediaPlayer::durationChanged,
            this, [this](qint64 dur){ setDurationInternal(dur); });

    connect(m_player, &QMediaPlayer::playbackStateChanged,
            this, [this](){
                setPlaying(m_player->playbackState() == QMediaPlayer::PlayingState);
            });
}

UsbPlayer::~UsbPlayer()
{
}

bool UsbPlayer::isVideo() const
{
    return m_isVideo;
}

void UsbPlayer::setVideoSink(QVideoSink* sink)
{
    m_player->setVideoSink(sink);
}

void UsbPlayer::activate()
{
    scanUsb();
    if (!m_files.isEmpty())
        playTrack(0);
    else
        setSongTitle("No Music Found on USB");
}

void UsbPlayer::deactivate()
{
    m_player->stop();
    setIsVideo(false);
}

void UsbPlayer::play()
{
    m_player->play();
}

void UsbPlayer::pause()
{
    m_player->pause();
}

void UsbPlayer::stop()
{
    m_player->stop();
}

void UsbPlayer::next()
{
    if (!m_files.isEmpty()) {
        m_index = (m_index + 1) % m_files.size();
        playTrack(m_index);
    }
}

void UsbPlayer::prev()
{
    if (!m_files.isEmpty()) {
        m_index = (m_index - 1 + m_files.size()) % m_files.size();
        playTrack(m_index);
    }
}

void UsbPlayer::togglePlayPause()
{
    if (m_player->playbackState() == QMediaPlayer::PlayingState)
        m_player->pause();
    else
        m_player->play();
}

void UsbPlayer::seek(qint64 pos)
{
    m_player->setPosition(pos);
}

void UsbPlayer::setVolume(float level)
{
    if (m_player->audioOutput())
        m_player->audioOutput()->setVolume(level);
}

void UsbPlayer::setMuted(bool muted)
{
    if (m_player->audioOutput())
        m_player->audioOutput()->setMuted(muted);
}

void UsbPlayer::setAudioOutput(QAudioOutput *output)
{
    m_player->setAudioOutput(output);
}

void UsbPlayer::scanUsb()
{
    m_files = QDir(m_usbPath).entryList(
        {"*.mp3","*.wav","*.flac","*.aac","*.mp4","*.mkv","*.avi","*.mov","*.wmv"},
        QDir::Files);
}

void UsbPlayer::playTrack(int index)
{
    if (index < 0 || index >= m_files.size())
        return;

    m_index = index;
    QString fileName = m_files.at(m_index);
    QString ext = fileName.section('.', -1).toLower();

    bool video = (ext == "mp4" || ext == "mkv" || ext == "avi" || ext == "mov" || ext == "wmv");
    setIsVideo(video);

    setSongTitle(fileName.section('.', 0, -2));
    m_player->setSource(QUrl::fromLocalFile(m_usbPath + "/" + fileName));
    m_player->play();
}

void UsbPlayer::setIsVideo(bool value)
{
    if (m_isVideo == value)
        return;
    m_isVideo = value;
    emit isVideoChanged();
}