
class CAdpcm
{
public:
    CAdpcm(void);
    ~CAdpcm(void);
    
    void EncoderClr(void);
    void DecoderClr(void);
    
    void ADPCMEncode(unsigned char *pRaw, int nLenRaw, unsigned char *pBufEncoded);
    void ADPCMDecode(char *pDataCompressed, int nLenData, char *pDecoded);
    void DecoderGetIndex(int * sample, int * index);
    void EncoderGetIndex(int * sample, int * index);
    
    int m_nEnAudioPreSample;
    int m_nEnAudioIndex;
    int m_nDeAudioPreSample;
    int m_nDeAudioIndex;
    
};

