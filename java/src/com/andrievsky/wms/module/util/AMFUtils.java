package com.andrievsky.wms.module.util;

import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.Date;

import com.wowza.wms.amf.AMFData;
import com.wowza.wms.amf.AMFDataArray;
import com.wowza.wms.amf.AMFDataItem;
import com.wowza.wms.amf.AMFDataObj;

public class AMFUtils {

	public static AMFData encodeCustomObject(Object o) {
		if (o instanceof Iterable)
		{
			AMFDataArray list = new AMFDataArray();
			for (Object oo : ((Iterable)o))
				list.add(encodeCustomObject(oo));
			return list;
		}
		if (o instanceof Array)
		{
			AMFDataArray array = new AMFDataArray();
			int len = Array.getLength(o);
			for (int i=0;i<len;i++)
				array.add(encodeCustomObject(Array.get(o, i)));
			return array;
		}
		
		
		if (o instanceof Boolean)
			return new AMFDataItem((Boolean)o);
		if (o instanceof Date)
			return new AMFDataItem((Date) o);
		if (o instanceof Double)
			return new AMFDataItem((Double)o);
		if (o instanceof Integer)
			return new AMFDataItem((Integer)o);
		if (o instanceof Long)
			return new AMFDataItem((Long)o);
		if (o instanceof String)
			return new AMFDataItem((String)o);
		
		//NULL
		if (o == null)
			return new AMFDataItem();
		
		
		AMFDataObj obj = new AMFDataObj();
		
		Class c = o.getClass();
		obj.setClassName(c.getName());
		
		System.out.println("Encoding: "+c.getName());
		Field[] fields = c.getFields();
		for (Field f : fields)
		{
			//Skip static fields
			if ( (f.getModifiers() & Modifier.STATIC) == 0)
			{
				obj.getTrait().addMember(f.getName());
				
				try{
					if ( (f.getModifiers() & Modifier.TRANSIENT) == 0)
						obj.put(f.getName(), encodeCustomObject(f.get(o)));
					else
						obj.put(f.getName(), new AMFDataItem()); //Don't Send Any Value (transient)
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}
			}
		}
		
		return obj;
	}

}
