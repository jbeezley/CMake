/*============================================================================
  CMake - Cross Platform Makefile Generator
  Copyright 2014 Kitware, Inc., Insight Software Consortium

  Distributed under the OSI-approved BSD License (the "License");
  see accompanying file Copyright.txt for details.

  This software is distributed WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the License for more information.
============================================================================*/
#include "cmUuid.h"

#include <sstream>
#include <cstring>

#include <cmsys/MD5.h>
#include "cm_sha2.h"

cmUuid::cmUuid()
{
  Groups.push_back(4);
  Groups.push_back(2);
  Groups.push_back(2);
  Groups.push_back(2);
  Groups.push_back(6);
}

std::string cmUuid::FromMd5(std::vector<unsigned char> const& uuidNamespace,
  std::string const& name) const
{
  std::vector<unsigned char> hashInput;
  this->CreateHashInput(uuidNamespace, name, hashInput);

  cmsysMD5_s *md5 = cmsysMD5_New();
  cmsysMD5_Initialize(md5);
  cmsysMD5_Append(md5, &hashInput[0], int(hashInput.size()));

  unsigned char digest[16] = {0};
  cmsysMD5_Finalize(md5, digest);

  cmsysMD5_Delete(md5);

  return this->FromDigest(digest, 3);
}

std::string cmUuid::FromSha1(std::vector<unsigned char> const& uuidNamespace,
    std::string const& name) const
{
  std::vector<unsigned char> hashInput;
  this->CreateHashInput(uuidNamespace, name, hashInput);

  SHA_CTX *sha = new SHA_CTX;
  SHA1_Init(sha);
  SHA1_Update(sha, &hashInput[0], hashInput.size());

  unsigned char digest[SHA1_DIGEST_LENGTH] = {0};
  SHA1_Final(digest, sha);

  delete sha;

  return this->FromDigest(digest, 5);
}

void cmUuid::CreateHashInput(std::vector<unsigned char> const& uuidNamespace,
  std::string const& name, std::vector<unsigned char> &output) const
{
  output = uuidNamespace;

  if(name.size())
    {
    output.resize(output.size() + name.size());

    std::memcpy(&output[0] + uuidNamespace.size(),
      name.c_str(), name.size());
    }
}

std::string cmUuid::FromDigest(
  const unsigned char* digest, int version) const
{
  unsigned char uuid[16] = {0};
  std::memcpy(uuid, digest, 16);

  uuid[6] &= 0xF;
  uuid[6] |= (version << 4);

  uuid[8] &= 0x3F;
  uuid[8] |= 0x80;

  return this->BinaryToString(uuid);
}

bool cmUuid::StringToBinary(std::string const& input,
  std::vector<unsigned char> &output) const
{
  output.clear();
  output.reserve(16);

  if(input.length() != 36)
    {
    return false;
    }
  size_t index = 0;
  for(size_t i = 0; i < this->Groups.size(); ++i)
    {
    if(i != 0 && input[index++] != '-')
      {
      return false;
      }
    size_t digits = this->Groups[i] * 2;
    if(!StringToBinaryImpl(input.substr(index, digits), output))
      {
      return false;
      }

    index += digits;
    }

  return true;
}

std::string cmUuid::BinaryToString(const unsigned char* input) const
{
  std::stringstream output;

  size_t inputIndex = 0;
  for(size_t i = 0; i < this->Groups.size(); ++i)
    {
    if(i != 0)
      {
      output << "-";
      }

    size_t bytes = this->Groups[i];
    for(size_t j = 0; j < bytes; ++j)
      {
      int byte = input[inputIndex++];
      if(byte <= 0xF)
        {
        output << "0";
        }
      output << std::hex << byte;
      }
    }

  return output.str();
}

bool cmUuid::StringToBinaryImpl(std::string const& input,
  std::vector<unsigned char> &output) const
{
  if(input.size()%2)
    {
    return false;
    }

  for(size_t i = 0; i < input.size(); i +=2)
    {
    char c1 = 0;
    if(!IntFromHexDigit(input[i], c1))
      {
      return false;
      }

    char c2 = 0;
    if(!IntFromHexDigit(input[i + 1], c2))
      {
      return false;
      }

    output.push_back(char(c1 << 4 | c2));
    }

  return true;
}

bool cmUuid::IntFromHexDigit(char input, char& output) const
{
  if(input >= '0' && input <= '9')
    {
    output = input - '0';
    return true;
    }
  else if(input >= 'a' && input <= 'f')
    {
    output = input - 'a' + 0xA;
    return true;
    }
  else if(input >= 'A' && input <= 'F')
    {
    output = input - 'A' + 0xA;
    return true;
    }
  else
    {
    return false;
    }
}
