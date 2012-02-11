//+------------------------------------------------------------------+
//|                                               libINIFileFunc.mq4 |
//|                      Copyright � 2011, Morochin <artamir> Artiom |
//|               http://forexmd.ucoz.org  e-mail: artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org  e-mail: artamir@yandex.ru"

#import "kernel32.dll"
  int GetPrivateProfileStringA
      ( string SectionName,    // ������������ ������
        string KeyName,        // ������������ ���������
        string Default,        // �������� �� ���������
        int ReturnedString[], // ������������ �������� ���������
        int    nSize,          // ������ ������ ��� �������� ���������
        string FileName);      // ������ ��� �����
  int WritePrivateProfileStringA
      ( string SectionName,    // ������������ ������
        string KeyName,        // ������������ ���������
        string sString,        // ������������ �������� ���������
        string FileName);      // ������ ��� �����
#import

/*///===================================================================
   ������: 2011.03.24
   ---------------------
   ��������:
      ������������� ��������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ���������:
       OP_SLTP = ����������� ��� ���� �������� ���������� �� � �� ��� �������         
       OP_SORD = ����������� ��� ���� �������� �������� �������
/*///-------------------------------------------------------------------
//string  libNAME = "libINIFileFunc";

#define  OP_SLTP   200
#define  OP_SORD   100

#define  CHK_SMBMN    500
#define  CHK_SMB      700
#define  CHK_MN       600
#define  CHK_TYMORE   400
#define  CHK_TYLESS   300
#define  CHK_TYEQ     200

//======================================================================


/*///==================================================================
// ������: 2011.03.24
//---------------------
// ��������:
// ���������� ������ ���������� ������ :)
//---------------------
// ����������:
//    ���
/*///-------------------------------------------------------------------
string libINIFile_Ver(){
   return("v1.0");
}
//======================================================================


//+----------------------------------------------------------------------------+
//    �����    : ������� ���� ��� artamir <artamir@yandex.ru>
//+----------------------------------------------------------------------------+
//    ������   : 2010.03.02
//    �������� : ���������� �� ��������� ������ �������� ��������
//+----------------------------------------------------------------------------+
//    �� �����:
//       comm  - ������, ���������� ���������, ����������� "@<ParamName_>"
//       rejim - ������, ���������� ��� ��������� <ParamName_>
//+----------------------------------------------------------------------------+
//    �� ������:
//       ������, ���������� �������� ��������� ���������
//       ��� "-1" ���� ��������� ��������� ��� � ������
//+----------------------------------------------------------------------------+
string returnComment(string comm, string rejim = ""){
   int posStart = -1;   //��������� ������� �������� ���������
   int posEnd = -1;     //�������� ������� �������� ���������
   
   string r = "@";               //�����������
   
   posEnd = StringFind(comm, r,0); // ���� �����
   if(rejim == ""){               //����� ������ ������ �������� (�����)
     return(StringSubstr(comm,0,posEnd));
   }
   
   posStart = StringFind(comm,rejim,0);
   if(posStart == -1){
      return("-1");
   }   
      
   posEnd = StringFind(comm,r,posStart+1);
   int slenRejim = StringLen(rejim);
   posStart = posStart+slenRejim;
   int len = iif(posEnd == -1,-1,posEnd-posStart);
   //---
   return(StringSubstr(comm,posStart,len));
      
}

/*///===================================================================
	������: 2011.07.25
	---------------------
	��������:
		��������� �������� ������ � ���� �������
	---------------------
	���. �������:
		���
	---------------------
	����������:
		���
/*///-------------------------------------------------------------------
void addRecordInFileOrders(string filename,	string file_comm){
	int ticket = StrToInteger(returnComment(file_comm,"@ot"));
	int grid = StrToInteger(returnComment(file_comm,"@g"));
	int level = StrToInteger(returnComment(file_comm,"@l"));
	int parent = StrToInteger(returnComment(file_comm,"@p"));
	int wasType = StrToInteger(returnComment(file_comm,"@w"));
	int isParent = StrToInteger(returnComment(file_comm,"@ip"));
	int step = StrToInteger(returnComment(file_comm,"@s"));
	
	int x = WriteIniString(filename, ticket, "isParent", isParent);
	WriteIniString(filename, ticket, "grid", grid);
	WriteIniString(filename, ticket, "level", level);
	WriteIniString(filename, ticket, "parent", parent);
	WriteIniString(filename, ticket, "wasType", wasType);
	WriteIniString(filename, ticket, "step", step);
}
//======================================================================

/*///===================================================================
	������: 2011.06.26
	---------------------
	��������:
		���������� �������� ��������� �� ��������� �����
	---------------------
	���. �������:
		���
	---------------------
	����������:
		filename
		section
		param
/*///-------------------------------------------------------------------
string libINIFF_ReadParam(string filename, string section, string param){
	
}
//======================================================================


//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   FileName    - ������ ��� �����                                 |
//|   SectionName - ������������ ������                              |
//|   KeyName     - ������������ ���������                           |
//|   Default     - �������� ��������� �� ���������                  |
//+------------------------------------------------------------------+  
string ReadIniString(string FileName, string SectionName, string KeyName, 
                     string Default = "-1")
{
   int iBuffer[16384];
   ArrayInitialize(iBuffer, 0);  
   int nValue = GetPrivateProfileStringA(SectionName, KeyName, Default, 
                                          iBuffer, 65535, FileName);
   if(nValue>0){
      string Buffer = "";
      int n=0;
      string iChars[4];
      for(int k=0; k<(nValue-1)/4+1; k++){
         if(iBuffer[k]==0)break;
           
         for(int i = 0; i < 4; i++){
            iChars[i] = CharToStr(iBuffer[k] & 255);
            iBuffer[k] = iBuffer[k] >> 8;       
            n++;
         }
         
         Buffer = StringConcatenate(Buffer, iChars[0], iChars[1], iChars[2], iChars[3]);
      }  
      return(StringSubstr(Buffer, 0, nValue));
   }
   else
     return(Default);
}

//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   FileName    - ������ ��� �����                                 |
//|   SectionName - ������������ ������                              |
//|   KeyName     - ������������ ���������                           |
//|   bDefault    - �������� ��������� �� ���������                  |
//+------------------------------------------------------------------+
bool ReadIniBool(string FileName, string SectionName, string KeyName, 
                 bool bDefault = False)
  {
   string Default;
   if(bDefault) 
       Default = "1"; 
   else 
       Default = "0";
   return( ReadIniString(FileName, SectionName, KeyName, Default) != "0");    
  }
  
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   FileName    - ������ ��� �����                                 |
//|   SectionName - ������������ ������                              |
//|   KeyName     - ������������ ���������                           |
//|   dDefault    - �������� ��������� �� ���������                  |
//+------------------------------------------------------------------+
double ReadIniDouble(string FileName, string SectionName, string KeyName, 
                     double dDefault = 0.0)
  {
   string Default = DoubleToStr(dDefault, 8);
   return(StrToDouble( ReadIniString(FileName, SectionName, KeyName, Default)));
  }
  
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   FileName    - ������ ��� �����                                 |
//|   SectionName - ������������ ������                              |
//|   KeyName     - ������������ ���������                           |
//|   iDefault    - �������� ��������� �� ���������                  |
//+------------------------------------------------------------------+
datetime ReadIniTime(string FileName, string SectionName, string KeyName, 
                   datetime dtDefault = 0)
  {
   string Default = TimeToStr(dtDefault, TIME_DATE)+" "+TimeToStr(dtDefault, TIME_SECONDS);
   return(StrToTime( ReadIniString(FileName, SectionName, KeyName, Default)));
  }
  
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   FileName    - ������ ��� �����                                 |
//|   SectionName - ������������ ������                              |
//|   KeyName     - ������������ ���������                           |
//|   iDefault    - �������� ��������� �� ���������                  |
//+------------------------------------------------------------------+
int ReadIniInteger(string FileName, string SectionName, string KeyName, 
                   int iDefault = -1)
{
   string Default = DoubleToStr(iDefault, 0);
   return(StrToInteger( ReadIniString(FileName, SectionName, KeyName, Default) ) );
}

//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   FileName    - ������ ��� �����                                 |
//|   SectionName - ������������ ������                              |
//|   KeyName     - ������������ ���������                           |
//|   aiParam     - ������ �������� ������������ ���������           |
//+------------------------------------------------------------------+
void ReadIniArrayInt(string FileName, string SectionName, string KeyName, int& aiParam[])
  {
   int    i = 0, np;
   string st;
   string ReturnedString = ReadIniString(FileName, SectionName, KeyName, "");

   if(ReturnedString != "")
     {
       while(StringLen(ReturnedString) > 0)
         {
           np = StringFind(ReturnedString, ",");
           if(np < 0)
             {
               st = ReturnedString;
               ReturnedString = "";
             } 
           else 
             {
               st = StringSubstr(ReturnedString, 0, np);
               ReturnedString = StringSubstr(ReturnedString, np + 1);
             }
           i++;
           ArrayResize(aiParam, i);
           aiParam[i-1] = StrToInteger(st);
         }
     } 
   else 
        ArrayResize(aiParam, 0);
  }
  
  
  
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   FileName    - ������ ��� �����                                 |
//|   SectionName - ������������ ������                              |
//|   KeyName     - ������������ ���������                           |
//|   aiParam     - ������ �������� ������������� ���������          |
//+------------------------------------------------------------------+
void WriteIniArrayInt(string FileName, string SectionName, string KeyName, 
                      int& aiParam[])
  {
   int    as = ArraySize(aiParam);
   string sString = "";
   for(int i = 0; i < as; i++)
     {
       sString = sString + DoubleToStr(aiParam[i], 0);
       if(i < as - 1) 
           sString = sString + ",";
     }
   int nValue = WritePrivateProfileStringA(SectionName, KeyName, sString, 
                                           FileName);
  }
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   FileName    - ������ ��� �����                                 |
//|   SectionName - ������������ ������                              |
//|   KeyName     - ������������ ���������                           |
//|   bParam      - ������������ �������� ���������                  |
//+------------------------------------------------------------------+
void WriteIniBool(string FileName, string SectionName, string KeyName, 
                  bool bParam)
  {
   string sString;
   if(bParam) 
       sString = "1"; 
   else 
       sString = "0";
   int nValue = WritePrivateProfileStringA(SectionName, KeyName, sString, 
                                           FileName);
  }
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   FileName    - ������ ��� �����                                 |
//|   SectionName - ������������ ������                              |
//|   KeyName     - ������������ ���������                           |
//|   dParam      - ������������ �������� ���������                  |
//+------------------------------------------------------------------+
void WriteIniDouble(string FileName, string SectionName, string KeyName, 
                    double dParam)
  {
   string sString = DoubleToStr(dParam, 8);
   int nValue = WritePrivateProfileStringA(SectionName, KeyName, sString, 
                                           FileName);
  }
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   FileName    - ������ ��� �����                                 |
//|   SectionName - ������������ ������                              |
//|   KeyName     - ������������ ���������                           |
//|   iParam      - ������������ �������� ���������                  |
//+------------------------------------------------------------------+
void WriteIniTime(string FileName, string SectionName, string KeyName, 
                     datetime dtParam)
  {
   string sString = TimeToStr(dtParam, TIME_DATE) + " " + TimeToStr(dtParam, TIME_SECONDS);
   int nValue = WritePrivateProfileStringA(SectionName, KeyName, sString, 
                                           FileName);
  }
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   FileName    - ������ ��� �����                                 |
//|   SectionName - ������������ ������                              |
//|   KeyName     - ������������ ���������                           |
//|   iParam      - ������������ �������� ���������                  |
//+------------------------------------------------------------------+
void WriteIniInteger(string FileName, string SectionName, string KeyName, 
                     int iParam)
  {
   string sString = DoubleToStr(iParam, 0);
   int nValue = WritePrivateProfileStringA(SectionName, KeyName, sString, 
                                           FileName);
  }
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   FileName    - ������ ��� �����                                 |
//|   SectionName - ������������ ������                              |
//|   KeyName     - ������������ ���������                           |
//|   sParam      - ������������ �������� ���������                  |
//+------------------------------------------------------------------+
int WriteIniString(string FileName, string SectionName, string KeyName, 
                    string sParam)
  {
   int nValue = WritePrivateProfileStringA(SectionName, KeyName, sParam, 
                                           FileName);
	return(nValue);									   
  }
//+------------------------------------------------------------------+

