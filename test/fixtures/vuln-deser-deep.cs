using System.Runtime.Serialization.Formatters.Binary;
using System.Xml;
BinaryFormatter bf = new BinaryFormatter();
JsonConvert.DeserializeObject(data, Type);
NetDataContractSerializer ndcs = new NetDataContractSerializer();
XmlReader.Create(data);
XmlDocument.Load(data);
DataSet.ReadXml(data);
